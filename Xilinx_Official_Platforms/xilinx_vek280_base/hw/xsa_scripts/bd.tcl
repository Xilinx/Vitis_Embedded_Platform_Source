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

set_property board_part xilinx.com:vek280:part0:* [current_project]

instantiate_example_design -template xilinx.com:design:ext_platform:1.0 -design vitis_design -options { Clock_Options.VALUE {clk_out1 625.000 0 true clk_out2 100 1 false } Include_AIE.VALUE true Include_BDC.VALUE false IRQS.VALUE 63}

validate_bd_design
save_bd_design

#write_bd_tcl -f ../xsa_scripts/reference_bd.tcl

update_compile_order -fileset sim_1
update_compile_order -fileset sources_1



