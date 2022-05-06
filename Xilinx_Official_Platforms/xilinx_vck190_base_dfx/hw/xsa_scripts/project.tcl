#
# (c) Copyright 2021 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# 
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
#

################################################################
# This is a generated script based on design: xilinx_vck190_base

#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
  proc get_script_folder {} {
    set script_path [file normalize [info script]]
    set script_folder [file dirname $script_path]
    return $script_folder
  }
}
variable script_folder
set script_folder [_tcl::get_script_folder]

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./xilinx_vck190_base/xilinx_vck190_base.xpr> in the current working folder.
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
