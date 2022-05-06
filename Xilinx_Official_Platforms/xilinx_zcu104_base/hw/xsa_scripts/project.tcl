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

################################################################
# This is a generated script based on design: xilinx_zcu104_base

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

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source xilinx_zcu104_base_xsa.tcl


# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   set_param board.repoPaths $::env(XILINX_VIVADO)/data/xhub/boards/XilinxBoardStore/boards/Xilinx
   set projName "my_project"
   set my_board [get_board_parts xilinx.com:zcu104:part0:* -latest_file_version]
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
