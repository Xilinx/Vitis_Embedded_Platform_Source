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

#ifndef __TASK_H__
#define __TASK_H__

#include "AlignedAllocator.h"
#include "ApiHandle.h"

#include <ap_int.h>
#include <iostream>
#include <vector>
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS
#include "CL/cl_ext_xilinx.h"
#include "CL/opencl.h"
#include "xcl2.hpp"

#include <CL/cl2.hpp>

class Task
{
    std::vector<ap_int<32>, AlignedAllocator<ap_int<32>>> m_out;
    unsigned int m_bufferSize;

    cl_event m_inEv;
    cl_event m_outEv;
    cl_event m_doneEv;

    cl_mem m_outBuffer[1];

    bool m_hasRun;

public:
    cl_event *getDoneEv() { return &m_doneEv; }
    cl_int err;
    Task(unsigned int bufferSize) : m_bufferSize(bufferSize),
                                    m_out(bufferSize),
                                    m_hasRun(false)
    {
    }
    Task(const Task &t) : m_bufferSize(t.m_bufferSize),
                          m_out(t.m_bufferSize),
                          m_hasRun(false)
    {
    }
    ~Task()
    {
        if (m_hasRun) {
            clReleaseMemObject(m_outBuffer[0]);

            clReleaseEvent(m_inEv);
            clReleaseEvent(m_outEv);
            clReleaseEvent(m_doneEv);
        }
    }
    void run(ApiHandle &api, cl_event *prevEvent = nullptr)
    {
        cl_int err;
#if 0
   OCL_CHECK(err,m_outBuffer[0] = clCreateBuffer(api.getContext(),
				   CL_MEM_WRITE_ONLY,
				   m_bufferSize*sizeof(int),
				   m_out.data(),
				   &err));
#endif
        OCL_CHECK(err, m_outBuffer[0] = clCreateBuffer(api.getContext(),
                                                       CL_MEM_USE_HOST_PTR | CL_MEM_WRITE_ONLY,
                                                       m_bufferSize * sizeof(int),
                                                       &m_out[0],
                                                       &err));

        if (prevEvent != nullptr) {
            OCL_CHECK(err, clEnqueueMigrateMemObjects(api.getQueue(), 1, &m_outBuffer[0],
                                                      0, 1, prevEvent, &m_inEv));
        }
        else {
            OCL_CHECK(err, clEnqueueMigrateMemObjects(api.getQueue(), 1, &m_outBuffer[0],
                                                      0, 0, nullptr, &m_inEv));
        }

        OCL_CHECK(err, clSetKernelArg(api.getKernel(), 0, sizeof(cl_mem), &m_outBuffer[0]));
        OCL_CHECK(err, clSetKernelArg(api.getKernel(), 1, sizeof(unsigned int), &m_bufferSize));

        OCL_CHECK(err, clEnqueueTask(api.getQueue(), api.getKernel(), 1, &m_inEv, &m_outEv));

        OCL_CHECK(err, clEnqueueMigrateMemObjects(api.getQueue(), 1, &m_outBuffer[0],
                                                  CL_MIGRATE_MEM_OBJECT_HOST,
                                                  1, &m_outEv, &m_doneEv));
        m_hasRun = true;
    }
    bool outputOk()
    {
        for (unsigned int i = 0; i < m_bufferSize; i++) {
            if (m_out[i] != i) {
                //     	  std::cout << "Error" << std::endl;
                std::cout << i << ":" << m_out[i] << std::endl;
                //     	  return false;
            }
        }
        return true;
    }
};

#endif
