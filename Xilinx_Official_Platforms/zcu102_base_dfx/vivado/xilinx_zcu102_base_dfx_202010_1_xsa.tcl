# -------------------------------------------------------------------------
# Copyright 2019 Xilinx Inc.
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
# -------------------------------------------------------------------------
puts "INFO: (Xilinx Acceleration Development Board Reference Design) creating emulation project and constructing BD"
source create_emu_design.tcl

# Project
puts "INFO: (Xilinx Acceleration Development Board Reference Design) creating project and constructing BD"
source create_design.tcl

# Synthesis
puts "INFO: (Xilinx Acceleration Development Board Reference Design) launching synthesis"
source run_synth.tcl

# Implementation
puts "INFO: (Xilinx Acceleration Development Board Reference Design) launching implementation"
source run_impl.tcl

# XSA
puts "INFO: (Xilinx Acceleration Development Board Reference Design) opening implementation and writing DSA"
source write_xsa.tcl

##### write bitfiles
####puts "INFO: (Xilinx Acceleration Development Board Reference Design) opening implementation and writing bitfiles"
####source write_bitfile.tcl
##### Finish
####puts "INFO: (Xilinx Acceleration Development Board Reference Design) done"
