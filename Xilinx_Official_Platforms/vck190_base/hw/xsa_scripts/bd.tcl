#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************
################################################################
# This is a generated script based on design: vitis_design
# CED instantiation 
################################################################

set_property board_part xilinx.com:vck190:part0:* [current_project]

# Instatiate CED design with configurable properties
instantiate_example_design -template xilinx.com:design:edf_base:1.0 -design vitis_design

validate_bd_design
save_bd_design

#write_bd_tcl -f ../xsa_scripts/reference_bd.tcl

update_compile_order -fileset sim_1
update_compile_order -fileset sources_1



