#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

#get Platform Name
file mkdir build
cd build
set PLATFORM_NAME [lindex $argv 0]
set VER [lindex $argv 1]

puts "INFO: (Xilinx Acceleration Development Board Reference Design) creating emulation project and constructing BD"
source ../create_emu_design.tcl

# Project
puts "INFO: (Xilinx Acceleration Development Board Reference Design) creating project and constructing BD"
source ../create_design.tcl

# Synthesis
puts "INFO: (Xilinx Acceleration Development Board Reference Design) launching synthesis"
source ../run_synth.tcl

# Implementation
puts "INFO: (Xilinx Acceleration Development Board Reference Design) launching implementation"
source ../run_impl.tcl

# XSA
puts "INFO: (Xilinx Acceleration Development Board Reference Design) opening implementation and writing DSA"
source ../write_xsa.tcl

puts "INFO: (Xilinx Acceleration Development Board Reference Design) Write README.hw"
source ../write_readme.tcl
cd ..
##### write bitfiles
####puts "INFO: (Xilinx Acceleration Development Board Reference Design) opening implementation and writing bitfiles"
####source write_bitfile.tcl
##### Finish
####puts "INFO: (Xilinx Acceleration Development Board Reference Design) done"
