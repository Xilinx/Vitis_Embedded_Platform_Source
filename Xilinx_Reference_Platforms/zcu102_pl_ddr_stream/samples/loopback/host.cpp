/*
 * Copyright 2019 Xilinx, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "host.h"

#include <fcntl.h>
#include <fstream>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

static const int DATA_SIZE = 32;
off_t PL_DDR_ADDR          = 0x80000000;
typedef long long int u64;

static const std::string error_message =
    "Error: Result mismatch:\n"
    "i = %d CPU result = %d Device result = %d\n";

int main(int argc, char *argv[])
{

    //TARGET_DEVICE macro needs to be passed from gcc command line
    if (argc != 2) {
        std::cout << "Usage: " << argv[0] << " <xclbin>" << std::endl;
        return EXIT_FAILURE;
    }

    char *xclbinFilename = argv[1];

    // Compute the size of array in bytes
    size_t size_in_bytes = DATA_SIZE * sizeof(int);

    // Creates a vector of DATA_SIZE elements with an initial value of 10 and 32
    // using customized allocator for getting buffer alignment to 4k boundary

    std::vector<cl::Device> devices;
    cl::Device device;
    std::vector<cl::Platform> platforms;
    bool found_device = false;

    unsigned int ram_size = 0x1000;
    off_t ram_pbase       = 0x80000000; // physical base address
    u64 *ram64_vptr;
    int fd;

    // Map the RAM physical address into user space getting a virtual address for it
    if ((fd = open("/dev/mem", O_RDWR | O_SYNC)) != -1) {

        ram64_vptr = (u64 *)mmap(NULL, ram_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, ram_pbase);

        // Write to the memory that was mapped, use devmem from the command line of Linux to verify it worked
        // it could be read back here also
    }

    //traversing all Platforms To find Xilinx Platform and targeted
    //Device in Xilinx Platform
    cl::Platform::get(&platforms);
    for (size_t i = 0; (i < platforms.size()) & (found_device == false); i++) {
        cl::Platform platform    = platforms[i];
        std::string platformName = platform.getInfo<CL_PLATFORM_NAME>();
        if (platformName == "Xilinx") {
            devices.clear();
            platform.getDevices(CL_DEVICE_TYPE_ACCELERATOR, &devices);
            if (devices.size()) {
                device       = devices[0];
                found_device = true;
                break;
            }
        }
    }
    if (found_device == false) {
        std::cout << "Error: Unable to find Target Device "
                  << device.getInfo<CL_DEVICE_NAME>() << std::endl;
        return EXIT_FAILURE;
    }

    // Creating Context and Command Queue for selected device
    cl::Context context(device);
    cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE);

    // Load xclbin
    std::cout << "Loading: '" << xclbinFilename << "'\n";
    std::ifstream bin_file(xclbinFilename, std::ifstream::binary);
    bin_file.seekg(0, bin_file.end);
    unsigned nb = bin_file.tellg();
    bin_file.seekg(0, bin_file.beg);
    char *buf = new char[nb];
    bin_file.read(buf, nb);

    // Creating Program from Binary File
    cl::Program::Binaries bins;
    bins.push_back({buf, nb});
    devices.resize(1);
    cl::Program program(context, devices, bins);

    // This call will get the kernel object from program. A kernel is an
    // OpenCL function that is executed on the FPGA.
    cl::Kernel krnl_ps_to_mig(program, "krnl_ps_to_mig");
    cl::Kernel krnl_mig_to_ps(program, "krnl_mig_to_ps");

    // These commands will allocate memory on the Device. The cl::Buffer objects can
    // be used to reference the memory locations on the device.
    cl::Buffer buffer_a(context, CL_MEM_READ_ONLY, size_in_bytes);
    cl::Buffer buffer_b(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, size_in_bytes, ram64_vptr);
    cl::Buffer buffer_result(context, CL_MEM_WRITE_ONLY, size_in_bytes);

    //set the kernel Arguments
    int narg = 0;
    krnl_ps_to_mig.setArg(narg++, buffer_a);
    krnl_ps_to_mig.setArg(narg++, buffer_b);
    krnl_ps_to_mig.setArg(narg++, DATA_SIZE);
    narg = 0;
    krnl_mig_to_ps.setArg(narg++, buffer_b);
    krnl_mig_to_ps.setArg(narg++, buffer_result);
    krnl_mig_to_ps.setArg(narg++, DATA_SIZE);

    //We then need to map our OpenCL buffers to get the pointers
    int *ptr_a      = (int *)q.enqueueMapBuffer(buffer_a, CL_TRUE, CL_MAP_WRITE, 0, size_in_bytes);
    int *ptr_result = (int *)q.enqueueMapBuffer(buffer_result, CL_TRUE, CL_MAP_READ, 0, size_in_bytes);

    //setting input data
    for (int i = 0; i < DATA_SIZE; i++) {
        ptr_a[i] = i;
    }

    // Data will be migrated to kernel space
    q.enqueueMigrateMemObjects({buffer_a}, 0 /* 0 means from host*/);

    //Launch the Kernel
    std::cout << "Processing: 'q.enqueueTask(krnl_ps_to_mig);"
              << "'\n";
    q.enqueueTask(krnl_ps_to_mig);

    std::cout << "Processing: 'q.finish();"
              << "'\n";
    q.finish();

    std::cout << "Processing: ' q.enqueueTask(krnl_mig_to_ps);"
              << "'\n";
    q.enqueueTask(krnl_mig_to_ps);

    // The result of the previous kernel execution will need to be retrieved in
    // order to view the results. This call will transfer the data from FPGA to
    // source_results vector
    q.enqueueMigrateMemObjects({buffer_result}, CL_MIGRATE_MEM_OBJECT_HOST);

    std::cout << "Processing: 'q.finish();"
              << "'\n";
    q.finish();

    //Verify the result
    int match = 0;
    for (int i = 0; i < DATA_SIZE; i++) {
        int host_result = i;
        if (ptr_result[i] != host_result) {
            printf(error_message.c_str(), i, host_result, ptr_result[i]);
            match = 1;
        }
    }

    q.enqueueUnmapMemObject(buffer_a, ptr_a);
    q.enqueueUnmapMemObject(buffer_result, ptr_result);
    q.finish();

    close(fd);

    std::cout << "TEST " << (match ? "FAILED" : "PASSED") << std::endl;
    return (match ? EXIT_FAILURE : EXIT_SUCCESS);
}
