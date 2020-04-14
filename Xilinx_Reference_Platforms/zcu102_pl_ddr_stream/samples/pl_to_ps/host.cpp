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

#include <chrono>
#include <iostream>
#include <vector>
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS
#include "ApiHandle.h"
#include "CL/opencl.h"
#include "Task.h"

int main(int argc, char *argv[])
{

    // -- Environment / Usage Check -------------------------------------------

    char *xcl_mode = getenv("XCL_EMULATION_MODE");

    if (argc != 2) {
        printf("\nUsage: %s "
               "./xclbin/pass.<emulation_mode>.<dsa>.xclbin ",
               argv[0]);
        return EXIT_FAILURE;
    }
    char *binaryName = argv[1];

    // -- Common Parameters ---------------------------------------------------

    unsigned int numBuffers = 3;
    bool oooQueue           = false;
    unsigned int bufferSize = 1024;

    // -- Setup ---------------------------------------------------------------

    ApiHandle api(binaryName, oooQueue);

    std::cout << std::endl;
    std::cout << std::endl;
    std::vector<Task> tasks(numBuffers, Task(bufferSize));

    auto fpga_begin = std::chrono::high_resolution_clock::now();

    // -- Execution -----------------------------------------------------------

    for (unsigned int i = 0; i < numBuffers; i++) {
        tasks[i].run(api);
    }
    clFinish(api.getQueue());

    // -- Testing -------------------------------------------------------------

    auto fpga_end = std::chrono::high_resolution_clock::now();

    bool outputOk = true;
    for (unsigned int i = 0; i < numBuffers; i++) {
        outputOk = tasks[i].outputOk() && outputOk;
    }
    if (!outputOk) {
        std::cout << "FAIL: Output Corrupted" << std::endl;
        return 1;
    }
    // -- Performance Statistics ----------------------------------------------

    if (xcl_mode == NULL) {
        std::chrono::duration<double> fpga_duration = fpga_end - fpga_begin;

        double total = (double)bufferSize * numBuffers * 512 / (1024.0 * 1024.0);
        std::cout << std::endl;
        std::cout << "          Total data: " << total << " MBits" << std::endl;
        std::cout << "           FPGA Time: " << fpga_duration.count()
                  << " s" << std::endl;
        std::cout << "     FPGA Throughput: "
                  << total / fpga_duration.count()
                  << " MBits/s" << std::endl;
        std::cout << "FPGA PCIe Throughput: "
                  << (2 * total) / fpga_duration.count()
                  << " MBits/s" << std::endl;
    }
    std::cout << "\nPASS: Simulation" << std::endl;

    return 0;
}
