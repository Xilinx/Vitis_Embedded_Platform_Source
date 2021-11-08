# Copyright 2021 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

foreach BLI_tile [get_tiles -filter TILE_TYPE=~BLI_?RAM_ROCF_T?_TILE] {
    foreach BLI_bel [get_bels -of $BLI_tile] {
        if {[get_site_pins -quiet -of [get_nodes -quiet -uphill -of [get_nodes -uphill -of [get_nodes -uphill -of [get_nodes -uphill -of [get_site_pins -of [get_bel_pins */D -of $BLI_bel]]]]]] -filter NAME=~*/?_T*] != ""} {
            mark_objects -color red $BLI_bel
            set_property PROHIBIT TRUE $BLI_bel
        }
    }    
}
