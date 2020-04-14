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

//------------------------------------------------------------------------------
//
// kernel:  master_cnt_to_mig
//
// Purpose: Demonstrate Kernel
//

/*
    Kernel Implementation
    Arguments:
        out_r   (output)    --> Output data
        size  (input)     --> Size of data in Integer
		stream_in (input)  --> Input data
*/
#include "hls_stream.h"

#include <ap_axi_sdata.h>
extern "C"
{
    void krnl_cnt_to_mig(
        unsigned int *out_r, // Output Result
        int size,            // Size in integer
        hls::stream<ap_axiu<16, 0, 0, 0>> &stream_in)
    {
#pragma HLS INTERFACE axis port  = stream_in
#pragma HLS INTERFACE m_axi port = out_r offset = slave bundle = gmem
#pragma HLS INTERFACE s_axilite port = out_r bundle = control
#pragma HLS INTERFACE s_axilite port = size bundle = control
#pragma HLS INTERFACE s_axilite port = return bundle = control
        ap_axiu<16, 0, 0, 0> temp;

    LOOP:
        for (int j = 0; j < size; j++) {
#pragma HLS PIPELINE II = 1
            temp     = stream_in.read();
            out_r[j] = temp.data;
        }
    }
}
