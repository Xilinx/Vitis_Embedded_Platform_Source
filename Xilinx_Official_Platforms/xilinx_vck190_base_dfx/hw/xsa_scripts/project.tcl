#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

################################################################
# This is a generated script based on design: xilinx_vck190_base_dfx

#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################


# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./xilinx_vck190_base_dfx/xilinx_vck190_base_dfx.xpr> in the current working folder.
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  set_param board.repoPaths $::env(XILINX_VIVADO)/data/xhub/boards/XilinxBoardStore/boards/Xilinx
  set projName "my_project"
  set my_board [get_board_parts xilinx.com:vck190:part0:* -latest_file_version]
  create_project $projName ./$projName -part [get_property PART_NAME [get_board_parts $my_board]]
  set_property board_part $my_board [current_project]
}
#get Platform Name
set PLATFORM_NAME [lindex $argv 0]
set VER [lindex $argv 1]

# CHANGE DESIGN NAME HERE
variable design_name
set design_name vitis_design
create_bd_design $design_name

##emulation scripts.....
set_property PREFERRED_SIM_MODEL "tlm" [current_project]
########
