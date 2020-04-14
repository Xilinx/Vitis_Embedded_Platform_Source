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
#include "ert.h"
#include "xrt.h"

#include <chrono>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iostream>
#include <unistd.h>
#include <vector>

using namespace std::chrono;

#define BUF_SIZE (1024 * 1024 * 10)
#define NUM_BUFS 10

int main(int argc, char **argv)
{
    //XRT HOST CODE AREA START
    unsigned deviceIndex = 0;
    xclDeviceHandle xdevice;
    char fileName[1024];
    unsigned dest_buf[NUM_BUFS];
    uint64_t dest_buf_phy[NUM_BUFS];
    uint16_t *dest_buf_ptr[NUM_BUFS];

    if (argc != 2) {
        std::cerr << "Usage: stream_naive_xrt.elf <xclbin>" << std::endl;
        exit(EXIT_FAILURE);
    }

    std::strcpy(fileName, argv[1]);

    if (deviceIndex >= xclProbe()) {
        std::cerr << "Cannot find device index specified" << std::endl;
        exit(EXIT_FAILURE);
    }

    xdevice = xclOpen(deviceIndex, "", XCL_QUIET);

    std::cout << "Try to load " << fileName << std::endl;
    std::ifstream stream(fileName);
    stream.seekg(0, stream.end);
    int size = stream.tellg();
    stream.seekg(0, stream.beg);

    char *header = new char[size];
    stream.read(header, size);

    if (std::strncmp(header, "xclbin2", 8)) {
        std::cerr << "Invalid bitstream" << std::endl;
    }

    if (xclLoadXclBin(xdevice, (const xclBin *)header)) {
        delete[] header;
        std::cerr << "Load XCLBIN failed" << std::endl;
    }
    std::cout << "Finished load XCLBIN " << fileName << std::endl;
    delete[] header;

    //Allocate Buffers in Global Memory
    xclBOProperties prop;
    for (int i = 0; i < NUM_BUFS; i++) {
        dest_buf[i]     = xclAllocBO(xdevice, BUF_SIZE, XCL_BO_DEVICE_RAM, 0);
        dest_buf_phy[i] = !xclGetBOProperties(xdevice, dest_buf[i], &prop) ? prop.paddr : -1;
        dest_buf_ptr[i] = (uint16_t *)xclMapBO(xdevice, dest_buf[i], false);
    }

    // Lets use multiple commands in advance test
    unsigned execHandle[NUM_BUFS];
    void *execData[NUM_BUFS];

    for (int i = 0; i < NUM_BUFS; i++) {
        execHandle[i] = xclAllocBO(xdevice, 4096, xclBOKind(0), (1 << 31));
        execData[i]   = xclMapBO(xdevice, execHandle[i], true);
    }

    auto start_time  = system_clock::now();
    uint32_t cu_base = 0xA0000000;
    for (int i = 0; i < NUM_BUFS; i++) {
        auto ecmd = reinterpret_cast<ert_start_kernel_cmd *>(execData[i]);
        auto rsz  = 12;
        std::memset(ecmd, 0, (sizeof *ecmd) + rsz);
        ecmd->state   = ERT_CMD_STATE_NEW;
        ecmd->opcode  = ERT_EXEC_WRITE;
        ecmd->count   = 1 + rsz;
        ecmd->cu_mask = 0x1;

        ecmd->data[6]  = cu_base + 0xC; // Needs to skip 6 data. Those are reseved for other purpose. This requirement comes from OpenCL runtime.
        ecmd->data[7]  = dest_buf_phy[i] & 0xFFFFFFFF;
        ecmd->data[8]  = cu_base + 0x0C;
        ecmd->data[9]  = (dest_buf_phy[i] >> 32) & 0xFFFFFFFF;
        ecmd->data[10] = cu_base + 0x10;
        ecmd->data[11] = BUF_SIZE / 2;

        if (xclExecBuf(xdevice, execHandle[i])) {
            std::cout << "Unable to issue xclExecBuf : start_kernel" << std::endl;
            std::cout << "FAILED TEST\n";
            std::cout << "Write failed\n";
            return 1;
        }
    }

    for (int i = 0; i < NUM_BUFS; i++) {
        while (xclExecWait(xdevice, 100) == 0) {
            std::cout << "reentering wait...\n";
        };
    }
    //XRT HOST CODE AREA END

    auto end_time = system_clock::now();
    auto duration = duration_cast<microseconds>(end_time - start_time).count();

    // Check the results
    uint16_t last;
    bool first = true;
    bool pass  = true;

    for (int i = 1; i < NUM_BUFS; i++) {
        for (int j = 0; j < BUF_SIZE / 2; j++) {
            if (j == 0) {
                std::cout << std::endl
                          << "Buffer " << i << " at "
                          << std::hex << static_cast<void *>(dest_buf_ptr[i])
                          << std::endl;
                std::cout << "First: " << std::hex << dest_buf_ptr[i][j] << std::endl;
                if (first) {
                    first = false;
                }
                else if (dest_buf_ptr[i][j] != last + 1) {
                    pass = false;
                    std::cout << "ERROR: Buffer lost data! ";
                    std::cout << std::hex << dest_buf_ptr[i][j]
                              << " + 1 != " << last << std::endl;
                }
            }
            else if (j == ((BUF_SIZE / 2) - 1)) {
                last = dest_buf_ptr[i][j];
                std::cout << "Last:  " << dest_buf_ptr[i][j] << std::endl;
            }
            else if ((dest_buf_ptr[i][j] != (dest_buf_ptr[i][j + 1] - 1)) &&
                     !((dest_buf_ptr[i][j] == 0xffff) && (dest_buf_ptr[i][j + 1] == 0))) {
                std::cout << "ERROR: Loss of continuity at position "
                          << std::dec << j;
                std::cout << "! " << std::hex << dest_buf_ptr[i][j] << " + 1 != "
                          << dest_buf_ptr[i][j + 1] << std::endl;
                std::string name = "bad_data_" + std::to_string(i) + ".dat";
                std::ofstream bad_data(name, std::ofstream::binary);
                bad_data.write((char *)dest_buf_ptr[i], BUF_SIZE);
                bad_data.close();
                pass = false;
                break;
            }
        }
    }

    std::cout << "TEST " << (pass ? "PASSED" : "FAILED") << std::endl;

    std::cout << "Transferred " << std::dec << NUM_BUFS << " packets in "
              << (duration * 1.0) / 1000000 << " seconds. (" << ((uint64_t)NUM_BUFS * BUF_SIZE)
              << " Bytes) " << ((uint64_t)NUM_BUFS * BUF_SIZE / (1024 * 1024)) / ((duration * 1.0) / 1000000)
              << " MiB/s" << std::endl;

    // OpenCL will release buffers

    return 0;
}
