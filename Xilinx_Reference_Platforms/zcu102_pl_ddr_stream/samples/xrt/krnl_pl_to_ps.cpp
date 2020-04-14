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

#include "krnl_pl_to_ps.h"
void krnl_pl_to_ps(
    hls::stream<ap_axiu<16, 0, 0, 0>> &stream_in,
    unsigned short *out_r,
    unsigned int size)
{
#pragma HLS interface axis port = stream_in
//#pragma HLS interface m_axi port=din  offset=slave bundle=gmem
#pragma HLS interface m_axi port = out_r offset = direct bundle = gmem

#pragma HLS interface ap_none port = out_r bundle = control
#pragma HLS interface ap_none port = size bundle = control
#pragma HLS interface ap_ctrl_hs port = return bundle = control

    ap_axiu<16, 0, 0, 0> temp;

    for (int i = 0; i < size; i++) {
#pragma HLS pipeline
        temp     = stream_in.read();
        out_r[i] = temp.data;
    }
}
