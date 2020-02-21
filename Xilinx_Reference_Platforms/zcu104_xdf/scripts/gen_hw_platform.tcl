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

set name [get_property NAME [current_project]]
set output_file [format %s/../../platform_repo/tmp/xsa/%s.xsa [get_property DIRECTORY [current_project]] $name]
set bd zcu104_xdf.bd

open_bd_design [get_files $bd]

set_property PFM_NAME [format "xilinx.com:board:%s:1.0" $name] [get_files $bd]

set_property PFM.CLOCK { \
                             clk_out1 {id "0" is_default "true" status "fixed" proc_sys_reset "psr_300"} \
                             clk_out2 {id "1" is_default "false" status "fixed" proc_sys_reset "psr_600"} \
                         }  [get_bd_cells /clk_wiz_0]

set_property PFM.AXI_PORT { \
                                M_AXI_HPM0_FPD {memport "M_AXI_GP"} \
                                M_AXI_HPM1_FPD {memport "M_AXI_GP"} \
                                S_AXI_HP0_FPD {memport "S_AXI_HP" sptag "HP0" memory "zynq_ultra_ps_e_0 HP0_DDR_LOW"} \
                                S_AXI_HP1_FPD {memport "S_AXI_HP" sptag "HP1" memory "zynq_ultra_ps_e_0 HP1_DDR_LOW"} \
                                S_AXI_HP2_FPD {memport "S_AXI_HP" sptag "HP2" memory "zynq_ultra_ps_e_0 HP2_DDR_LOW"} \
                                S_AXI_HP3_FPD {memport "S_AXI_HP" sptag "HP3" memory "zynq_ultra_ps_e_0 HP3_DDR_LOW"} \
                            } [get_bd_cells /zynq_ultra_ps_e_0]

generate_target all [get_files $bd]
reset_run synth_1
launch_runs -jobs 20 synth_1
wait_on_run synth_1

# Set platform project properties
set_property platform.description                   "Minimal ZCU104 development platform for testing purposes" [current_project]
set_property platform.uses_pr                       false         [current_project]

set_property platform.design_intent.server_managed  "false" [current_project]
set_property platform.design_intent.external_host   "false" [current_project]
set_property platform.design_intent.embedded        "true" [current_project]
set_property platform.design_intent.datacenter      "false" [current_proj]

set_property platform.post_sys_link_tcl_hook        ./scripts/dynamic_postlink.tcl [current_project]
set_property platform.vendor                        "xilinx.com" [current_project]
set_property platform.board_id                      $name [current_project]
set_property platform.name                          $name [current_project]
set_property platform.version                       "1.0" [current_project]
set_property platform.platform_state                "pre_synth" [current_project]
set_property platform.ip_cache_dir                  [get_property ip_output_repo [current_project]] [current_project]

set_property platform.default_output_type           "xclbin" [current_project]

set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.PHYS_OPT_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]
set_property STEPS.ROUTE_DESIGN.ARGS.DIRECTIVE Explore [get_runs impl_1]

write_hw_platform -force $output_file
