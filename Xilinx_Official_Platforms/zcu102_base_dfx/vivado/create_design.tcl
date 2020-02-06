# *************************************************************************
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
# *************************************************************************

# Get current directory, used throughout script
set launchDir [file dirname [file normalize [info script]]]
set sourcesDir ${launchDir}/sources

# Create the project using board support
set projName "xilinx_zcu102_dynamic_0_1"
set projPart "xczu9eg-ffvb1156-2-e"
set projBoardPart "xilinx.com:zcu102:part0:3.2"
#set_param board.RepoPaths ${sourcesDir}/boardrepo/samsung/1.0
create_project $projName ./$projName -part $projPart
set_property board_part $projBoardPart [current_project]

# Set required environment variables and params
set_param project.enablePRFlowIPI 1
set_param project.enablePRFlowIPIOOC 1
set_param chipscope.enablePRFlow 1
set_param bd.skipSupportedIPCheck 1
set_param checkpoint.useBaseFileNamesWhileWritingDCP 1
set_param platform.populateFeatureRomInWriteHwPlatform 0

# Specify and refresh the IP local repo
set_property ip_repo_paths "${sourcesDir}/iprepo" [current_project]
update_ip_catalog

# Import HDL, XDC, and other files
import_files -fileset constrs_1 -norecurse ${sourcesDir}/constraints/static_impl_early.xdc
import_files -fileset constrs_1 -norecurse ${sourcesDir}/constraints/dynamic_impl.xdc
set_property used_in_synthesis false [get_files *imp*.xdc]
set_property processing_order EARLY [get_files  *early.xdc]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Set platform project properties
set_property platform.vendor                        "xilinx"     [current_project]
set_property platform.board_id                      "zcu102"    [current_project]
set_property platform.name                          "dynamic"    [current_project]
set_property platform.version                       "0.1"        [current_project]
set_property platform.description                   "This platform targets the ZCU102 Development Board. This platform features one PL and one PS channels of DDR4 SDRAM which are instantiated as required by the user kernels for high fabric resource availability ." [current_project]
set_property platform.platform_state                "impl"       [current_project]
set_property platform.uses_pr                       true         [current_project]
set_property platform.ocl_inst_path                 {pfm_top_i/dynamic_region}                                              [current_project]
set_property platform.board_memories                { {mem0 ddr4 2GB}} [current_project]
set_property platform.pre_sys_link_tcl_hook         ${sourcesDir}/misc/dynamic_prelink.tcl                                  [current_project]
set_property platform.post_sys_link_tcl_hook        ${sourcesDir}/misc/dynamic_postlink.tcl                                 [current_project]
set_property platform.run.steps.opt_design.tcl.post ${sourcesDir}/misc/dynamic_postopt.tcl                                  [current_project]

set_property platform.ip_cache_dir                  ${launchDir}/${projName}/${projName}.cache/ip                           [current_project]
set_property platform.synth_constraint_files        [list "${sourcesDir}/constraints/dynamic_impl.xdc,NORMAL,implementation"] [current_project]

set_property platform.design_intent.server_managed "false" [current_project]
set_property platform.design_intent.external_host "false" [current_project]
set_property platform.design_intent.embedded "true" [current_project]
set_property platform.design_intent.datacenter "false" [current_proj]
set_property platform.default_output_type "xclbin" [current_project]

# Set any other project properties
set_property STEPS.OPT_DESIGN.TCL.POST ${sourcesDir}/misc/dynamic_postopt.tcl [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]

# Construct reconfigurable BD and partition
create_bd_design pfm_dynamic
source ${sourcesDir}/misc/dynamic_prelink.tcl
source ${sourcesDir}/bd/dynamic.tcl
source ${sourcesDir}/misc/gen_hpfm_cmd_file.tcl
source ${sourcesDir}/misc/dynamic_bd_settings.tcl

# Construct static region BD
create_bd_design pfm_top
source ${sourcesDir}/bd/static.tcl
close_bd_design [get_bd_designs pfm_top]
open_bd_design  [get_files pfm_top.bd]

# Regenerate layout, validate, and save the BD
regenerate_bd_layout
validate_bd_design -force
save_bd_design

# Write BD wrapper HDL
set_property generate_synth_checkpoint true [get_files pfm_top.bd]
add_files -norecurse [make_wrapper -files [get_files pfm_top.bd] -top]
set_property top pfm_top_wrapper [current_fileset]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
