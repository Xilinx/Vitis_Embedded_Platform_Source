#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

# Create PFM attributes
set_property PFM_NAME "xilinx.com:xd:${PLATFORM_NAME}:${VER}" [get_files [current_bd_design].bd]

set_property PFM.IRQ {intr {id 0 range 32}}  [get_bd_cells /axi_intc_parent]


set_property PFM.AXI_PORT {S00_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S01_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S02_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S03_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S04_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S05_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S06_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S07_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S08_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S09_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S10_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S11_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S12_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S13_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S14_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S15_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S16_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S17_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S18_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S19_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S20_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S21_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S22_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S23_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S24_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S25_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S26_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S27_AXI {memport "S_AXI_NOC" sptag "LPDDR"}} [get_bd_cells /aggr_noc]

set_property PFM.AXI_PORT {S00_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0"} S01_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0"} S02_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0"} S03_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0"} S04_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0"} S05_AXI {memport "S_AXI_NOC" sptag "S_AXI_AIE" auto "false" memory "ai_engine_0 AIE_ARRAY_0"}} [get_bd_cells /ConfigNoc]

set_property PFM.CLOCK {clk_out1 {id "1" is_default "false" proc_sys_reset "psr_100mhz" status "fixed"} clk_out2 {id "0" is_default "false" proc_sys_reset "psr_150mhz" status "fixed"} clk_out3 {id "2" is_default "true" proc_sys_reset "psr_300mhz" status "fixed"} clk_out4 {id "3" is_default "false" proc_sys_reset "psr_75mhz" status "fixed"} clk_out5 {id "4" is_default "false" proc_sys_reset "psr_200mhz" status "fixed"} clk_out6 {id "5" is_default "false" proc_sys_reset "psr_400mhz" status "fixed"} clk_out7 {id "6" is_default "false" proc_sys_reset "psr_600mhz" status "fixed"}} [get_bd_cells /clk_wizard_0]

set_property PFM.AXI_PORT {M02_AXI {memport "M_AXI_GP" sptag "" memory ""} M03_AXI {memport "M_AXI_GP" sptag "" memory ""} M04_AXI {memport "M_AXI_GP" sptag "" memory ""}} [get_bd_cells /icn_ctrl_1]

set_property PFM.AXI_PORT {M01_AXI {memport "M_AXI_GP" sptag "" memory ""} M02_AXI {memport "M_AXI_GP" sptag "" memory ""} M03_AXI {memport "M_AXI_GP" sptag "" memory ""} M04_AXI {memport "M_AXI_GP" sptag "" memory ""} M05_AXI {memport "M_AXI_GP" sptag "" memory ""} M06_AXI {memport "M_AXI_GP" sptag "" memory ""} M07_AXI {memport "M_AXI_GP" sptag "" memory ""} M08_AXI {memport "M_AXI_GP" sptag "" memory ""} M09_AXI {memport "M_AXI_GP" sptag "" memory ""} M10_AXI {memport "M_AXI_GP" sptag "" memory ""} M11_AXI {memport "M_AXI_GP" sptag "" memory ""} M12_AXI {memport "M_AXI_GP" sptag "" memory ""} M13_AXI {memport "M_AXI_GP" sptag "" memory ""} M14_AXI {memport "M_AXI_GP" sptag "" memory ""} M15_AXI {memport "M_AXI_GP" sptag "" memory ""}} [get_bd_cells /icn_ctrl_2]

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
validate_bd_design
save_bd_design
