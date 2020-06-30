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

# Get current directory, used throughout script
if {[file exists emu_overlay]} {
  file delete -force emu_overlay
}

set launchDir [file dirname [file normalize [info script]]]
set sourcesDir ${launchDir}/sources

file mkdir emu_overlay
cd emu_overlay

# Create the project using board support
set projName "xilinx_zcu102_dynamic_0_1"
set projPart "xczu9eg-ffvb1156-2-e"
set projBoardPart "xilinx.com:zcu102:part0:3.2"
create_project $projName ./$projName -part $projPart
set_property board_part $projBoardPart [current_project]

# Set required environment variables and params
set_param project.enablePRFlowIPI 1
set_param project.enablePRFlowIPIOOC 1
set_param chipscope.enablePRFlow 1
set_param bd.skipSupportedIPCheck 1
set_param checkpoint.useBaseFileNamesWhileWritingDCP 1
set_param platform.populateFeatureRomInWriteHwPlatform 0

# Set DSA project properties
set_property dsa.vendor                        "xilinx"     [current_project]
set_property dsa.board_id                      "ZCU102"    [current_project]
set_property dsa.name                          "dynamic"    [current_project]
set_property dsa.version                       "0.1"        [current_project]
set_property dsa.description                   "This platform targets the ZCU102 Development Board. This platform features one PL and one PS channels of DDR4 SDRAM which are instantiated as required by the user kernels for high fabric resource availability ." [current_project]
set_property dsa.platform_state                "impl"       [current_project]
set_property dsa.uses_pr                       true         [current_project]
set_property dsa.ocl_inst_path                 {pfm_top_i/dynamic_region}                                              [current_project]
set_property dsa.board_memories                { {mem0 ddr4 2GB}} [current_project]
set_property dsa.pre_sys_link_tcl_hook         ${sourcesDir}/misc/dynamic_prelink.tcl                                  [current_project]
set_property dsa.post_sys_link_tcl_hook        ${sourcesDir}/misc/dynamic_postlink.tcl                                 [current_project]
set_property dsa.run.steps.opt_design.tcl.post ${sourcesDir}/misc/dynamic_postopt.tcl                                  [current_project]

set_property dsa.ip_cache_dir                  ${launchDir}/${projName}/${projName}.cache/ip                           [current_project]
set_property dsa.synth_constraint_files        [list "${sourcesDir}/constraints/dynamic_impl.xdc,NORMAL,implementation"] [current_project]

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
set_property platform.emu.post_sys_link_tcl_hook        ${sourcesDir}/misc/dynamic_postlink.tcl                                 [current_project]
set_property platform.emu.pre_sys_link_tcl_hook         ${sourcesDir}/misc/dynamic_prelink.tcl                                  [current_project]

validate_bd_design
save_bd_design
bd::utils::generate_hw_pfm_from_bd emu.hpfm
set_property platform.emu.hpfm_file                     emu.hpfm                                                                [current_project]

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

#From the Vivado project, write the contents of hw_emu dir which are ready to be packaged into the platform
write_hw_emu_dir -verbose
set overlay_dir hw_emu
exec chmod 755 ${overlay_dir}/dynamic_postlink.tcl
set fid [open "${overlay_dir}/dynamic_postlink.tcl" a ]
puts $fid "set_property generate_synth_checkpoint 0 \[get_files pfm_dynamic.bd\]"
puts $fid "set_property offset 0x00000000 \[get_bd_addr_segs {axi_vip_3/Master_AXI/SEG_interconnect_aximm_ddrmem3_M00_AXI_Reg}\]"
puts $fid "set_property range 2G \[get_bd_addr_segs {axi_vip_3/Master_AXI/SEG_interconnect_aximm_ddrmem3_M00_AXI_Reg}\]"
puts $fid "assign_bd_address -boundary -combine_segments"
close $fid
close_project
cd ../
