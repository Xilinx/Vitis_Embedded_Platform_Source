# *************************************************************************
#    ____  ____
#   /   /\/   /
#  /___/  \  /
#  \   \   \/    © Copyright 2017 Xilinx, Inc. All rights reserved.
#   \   \        This file contains confidential and proprietary
#   /   /        information of Xilinx, Inc. and is protected under U.S.
#  /___/   /\    and international copyright and other intellectual
#  \   \  /  \   property laws.
#   \___\/\___\
#
#
# *************************************************************************
#
# Disclaimer:
#
#       This disclaimer is not a license and does not grant any rights to
#       the materials distributed herewith. Except as otherwise provided in
#       a valid license issued to you by Xilinx, and to the maximum extent
#       permitted by applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE
#       "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
#       WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
#       INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
#       NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
#       (2) Xilinx shall not be liable (whether in contract or tort,
#       including negligence, or under any other theory of liability) for
#       any loss or damage of any kind or nature related to, arising under
#       or in connection with these materials, including for any direct, or
#       any indirect, special, incidental, or consequential loss or damage
#       (including loss of data, profits, goodwill, or any type of loss or
#       damage suffered as a result of any action brought by a third party)
#       even if such damage or loss was reasonably foreseeable or Xilinx
#       had been advised of the possibility of the same.
#
# Critical Applications:
#
#       Xilinx products are not designed or intended to be fail-safe, or
#       for use in any application requiring fail-safe performance, such as
#       life-support or safety devices or systems, Class III medical
#       devices, nuclear facilities, applications related to the deployment
#       of airbags, or any other applications that could lead to death,
#       personal injury, or severe property or environmental damage
#       (individually and collectively, "Critical Applications"). Customer
#       assumes the sole risk and liability of any use of Xilinx products
#       in Critical Applications, subject only to applicable laws and
#       regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS
# FILE AT ALL TIMES.
#
# *************************************************************************

# Get current directory, used throughout script
if {[file exists hw_emu]} {
  file delete -force hw_emu
}

set launchDir [file dirname [file normalize [info script]]]
set sourcesDir ${launchDir}/sources

file mkdir hw_emu
cd hw_emu

file copy  ${sourcesDir}/misc/dynamic_postlink.tcl .

# Create the project using board support
set_param board.repoPaths $::env(XILINX_VIVADO)/data/xhub/boards/XilinxBoardStore/boards/Xilinx
set projName "xilinx_zcu102_dynamic_0_1"
set my_board [get_board_parts xilinx.com:zcu102:part0:* -latest_file_version]
create_project $projName ./$projName -part [get_property PART_NAME [get_board_parts $my_board]] 
set_property board_part $my_board [current_project]

# Set required environment variables and params
set_param project.enablePRFlowIPI 1
set_param project.enablePRFlowIPIOOC 1
set_param chipscope.enablePRFlow 1
set_param bd.skipSupportedIPCheck 1
set_param checkpoint.useBaseFileNamesWhileWritingDCP 1
set_param platform.populateFeatureRomInWriteHwPlatform 0

set fid [open "./dynamic_postlink.tcl" a ]
puts $fid "set_property generate_synth_checkpoint 0 \[get_files pfm_dynamic.bd\]"
puts $fid "set_property offset 0x00000000 \[get_bd_addr_segs {axi_vip_3/Master_AXI/SEG_interconnect_aximm_ddrmem3_M00_AXI_Reg}\]"
puts $fid "set_property range 2G \[get_bd_addr_segs {axi_vip_3/Master_AXI/SEG_interconnect_aximm_ddrmem3_M00_AXI_Reg}\]"
close $fid

# Set DSA project properties
set_property platform.vendor                        "xilinx"     [current_project]
set_property platform.board_id                      "ZCU102"    [current_project]
set_property platform.name                          "dynamic"    [current_project]
set_property platform.version                       "0.1"        [current_project]
set_property platform.description                   "This platform targets the ZCU102 Development Board. This platform features one PL and one PS channels of DDR4 SDRAM which are instantiated as required by the user kernels for high fabric resource availability ." [current_project]
set_property platform.dr_inst_path                 {pfm_top_i/dynamic_region}                                              [current_project]
set_property platform.board_memories                { {mem0 ddr4 2GB}} [current_project]
set_property platform.pre_sys_link_overlay_tcl_hook         ${sourcesDir}/misc/dynamic_prelink.tcl                                  [current_project]
set_property platform.post_sys_link_overlay_tcl_hook        ./dynamic_postlink.tcl                                                  [current_project]


set_property platform.design_intent.server_managed "false" [current_project]
set_property platform.design_intent.external_host "false" [current_project]
set_property platform.design_intent.embedded "true" [current_project]
set_property platform.design_intent.datacenter "false" [current_proj]
set_property platform.default_output_type "xclbin" [current_project]
# Construct reconfigurable BD and partition
create_bd_design pfm_dynamic
source ${sourcesDir}/misc/dynamic_prelink.tcl
source ${sourcesDir}/bd/dynamic.tcl
source ${sourcesDir}/misc/gen_hpfm_cmd_file.tcl
source ${sourcesDir}/emulation_sources/dynamic_bd_settings.tcl

#Project properties that need to be set for platform
#set_property platform.emu.post_sys_link_tcl_hook        ${sourcesDir}/misc/dynamic_postlink.tcl                                 [current_project]
#set_property platform.emu.pre_sys_link_tcl_hook         ${sourcesDir}/misc/dynamic_prelink.tcl                                  [current_project]

validate_bd_design
save_bd_design
bd::utils::generate_hw_pfm_from_bd pfm_dynamic.hpfm
set_property platform.hpfm_file                     pfm_dynamic.hpfm                                                                [current_project]

set_property generate_synth_checkpoint 0 [get_files pfm_dynamic.bd]
#Construct static region BD
create_bd_design pfm_top
source ${sourcesDir}/emulation_sources/scripts/static.tcl
set_property SELECTED_SIM_MODEL tlm [get_bd_cells /static_region/zynq_ultra_ps_e_0]
close_bd_design [get_bd_designs pfm_top]
open_bd_design  [get_files pfm_top.bd]
# Write BD wrapper HDL
set_property generate_synth_checkpoint false [get_files pfm_top.bd]
add_files -norecurse [make_wrapper -files [get_files pfm_top.bd] -top]
set_property top pfm_top_wrapper [current_fileset]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
# Regenerate layout, validate, and save the BD
regenerate_bd_layout
validate_bd_design -force
save_bd_design
generate_target all [get_files pfm_dynamic.bd]
generate_target all [get_files pfm_top.bd]
import_files

update_compile_order
write_hw_platform -hw_emu -file hw_emu.xsa
#From the Vivado project, write the contents of hw_emu dir which are ready to be packaged into the platform
close_project
cd ../
