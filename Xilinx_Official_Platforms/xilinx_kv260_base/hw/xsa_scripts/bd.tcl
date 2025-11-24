#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************
################################################################
# This is a generated script based on design: vitis_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

set_property board_part xilinx.com:kv260_som:part0:* [current_project]

# Instatiate CED design with configurable properties

instantiate_example_design -template xilinx.com:design:MPSoC_ext_platform:1.0 -design MPSoC_ext_platform -options { Clock_Options.VALUE {clk_out1 150.000 0 true clk_out2 300.000 1 false clk_out3 75.000 2 false clk_out4 100.000 3 false clk_out5 200.000 4 false clk_out6 400.000 5 false clk_out7 600.000 6 false} Include_DDR.VALUE false}

validate_bd_design
save_bd_design

#write_bd_tcl -f ../xsa_scripts/reference_bd.tcl

update_compile_order -fileset sim_1
update_compile_order -fileset sources_1



