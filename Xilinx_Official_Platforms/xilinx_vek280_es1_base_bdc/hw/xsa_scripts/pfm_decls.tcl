#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

current_bd_design [get_bd_designs ext_bdc]

  # Create PFM attributes
  set_property PFM_NAME {xilinx.com:vek280_es:xilinx_vek280_es1_base_bdc_202320_1:1.0} [get_files [current_bd_design].bd]

  set_property PFM.AXI_PORT {S00_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S01_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S02_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S03_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S04_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S05_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S06_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S07_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S08_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S09_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S10_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S11_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S12_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S13_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S14_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S15_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S16_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S17_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S18_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S19_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"} S20_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0" is_range "true"}} [get_bd_cells /ConfigNoc]
  set_property PFM.AXI_PORT {S00_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S01_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S02_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S03_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S04_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S05_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S06_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S07_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S08_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S09_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S10_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S11_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S12_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S13_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S14_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S15_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S16_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S17_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S18_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S19_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"} S20_AXI {memport "S_AXI_NOC" sptag "LPDDR" memory "" is_range "true"}} [get_bd_cells /aggr_noc]
  set_property PFM.CLOCK {clk_out1 {id "0" is_default "false" proc_sys_reset "/proc_sys_reset_0" status "fixed"} clk_out2 {id "1" is_default "false" proc_sys_reset "/proc_sys_reset_1" status "fixed"} clk_out3 {id "2" is_default "true" proc_sys_reset "/proc_sys_reset_2" status "fixed"} clk_out4 {id "3" is_default "false" proc_sys_reset "/proc_sys_reset_3" status "fixed"} clk_out5 {id "4" is_default "false" proc_sys_reset "/proc_sys_reset_4" status "fixed"} clk_out6 {id "5" is_default "false" proc_sys_reset "/proc_sys_reset_5" status "fixed"} clk_out7 {id "6" is_default "false" proc_sys_reset "/proc_sys_reset_6" status "fixed"}} [get_bd_cells /clk_wizard_0]
  set_property PFM.IRQ {intr {id 0 range 31}} [get_bd_cells /axi_intc_0]
  set_property PFM.AXI_PORT {M03_AXI {memport "M_AXI_GP" sptag "" memory ""} M04_AXI {memport "M_AXI_GP" sptag "" memory ""} } [get_bd_cells /axi_smc_vip_hier/icn_ctrl]
  set_property PFM.AXI_PORT {M01_AXI {memport "M_AXI_GP" sptag "" memory ""} M02_AXI {memport "M_AXI_GP" sptag "" memory ""} M03_AXI {memport "M_AXI_GP" sptag "" memory ""} M04_AXI {memport "M_AXI_GP" sptag "" memory ""} M05_AXI {memport "M_AXI_GP" sptag "" memory ""} M06_AXI {memport "M_AXI_GP" sptag "" memory ""} M07_AXI {memport "M_AXI_GP" sptag "" memory ""} M08_AXI {memport "M_AXI_GP" sptag "" memory ""} M09_AXI {memport "M_AXI_GP" sptag "" memory ""} M10_AXI {memport "M_AXI_GP" sptag "" memory ""} M11_AXI {memport "M_AXI_GP" sptag "" memory ""} M12_AXI {memport "M_AXI_GP" sptag "" memory ""} M13_AXI {memport "M_AXI_GP" sptag "" memory ""} M14_AXI {memport "M_AXI_GP" sptag "" memory ""} M15_AXI {memport "M_AXI_GP" sptag "" memory ""}} [get_bd_cells /axi_smc_vip_hier/icn_ctrl_0]
  set_property PFM.AXI_PORT {M01_AXI {memport "M_AXI_GP" sptag "" memory ""} M02_AXI {memport "M_AXI_GP" sptag "" memory ""} M03_AXI {memport "M_AXI_GP" sptag "" memory ""} M04_AXI {memport "M_AXI_GP" sptag "" memory ""} M05_AXI {memport "M_AXI_GP" sptag "" memory ""} M06_AXI {memport "M_AXI_GP" sptag "" memory ""} M07_AXI {memport "M_AXI_GP" sptag "" memory ""} M08_AXI {memport "M_AXI_GP" sptag "" memory ""} M09_AXI {memport "M_AXI_GP" sptag "" memory ""} M10_AXI {memport "M_AXI_GP" sptag "" memory ""} M11_AXI {memport "M_AXI_GP" sptag "" memory ""} M12_AXI {memport "M_AXI_GP" sptag "" memory ""} M13_AXI {memport "M_AXI_GP" sptag "" memory ""} M14_AXI {memport "M_AXI_GP" sptag "" memory ""} M15_AXI {memport "M_AXI_GP" sptag "" memory ""}} [get_bd_cells /axi_smc_vip_hier/icn_ctrl_1]


 
# Platform_Properties
set_property platform.design_intent.embedded "true" [current_project]
set_property platform.extensible "true" [current_project]
set_property platform.design_intent.server_managed "false" [current_project]
set_property platform.design_intent.external_host "false" [current_project]
set_property platform.design_intent.datacenter "false" [current_project]
set_property platform.uses_pr  "false" [current_project]
set_property platform.emu.dr_bd_inst_path {vitis_design_wrapper_sim_wrapper/vitis_design_wrapper_i/vitis_design_i} [current_project]
set_property platform.default_output_type "xclbin" [current_project]
set_property platform.extensible true [current_project]

#setting Platform level param to have PDI in hw xsa
set_param platform.forceEnablePreSynthPDI true

#Importing Placement Files
import_files -fileset utils_1 -norecurse ./../data/qor_scripts/prohibit_select_bli_bels_for_hold.tcl
set_property platform.run.steps.place_design.tcl.pre [get_files prohibit_select_bli_bels_for_hold.tcl] [current_project]
#set_property platform.post_sys_link_overlay_tcl_hook  [get_files ../xsa_scripts/sys_link_overlay.post.tcl] [current_project]

#set_property platform.post_sys_link_overlay_tcl_hook  ../xsa_scripts/sys_link_overlay.post.tcl [current_project]

validate_bd_design
save_bd_design
