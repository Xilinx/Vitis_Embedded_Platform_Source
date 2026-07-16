#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************
################################################################
# This is a generated script based on design: vitis_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

 # Create ports

  # Create instance: ctrl_smc, and set properties
  set ctrl_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 ctrl_smc ]
  set_property -dict [list \
    CONFIG.ADVANCED_PROPERTIES {__experimental_features__ {legacy_low_area_mode 1}} \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $ctrl_smc


  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property -dict [list \
    CONFIG.C_ASYNC_INTR {0xFFFFFFFF} \
    CONFIG.C_IRQ_CONNECTION {1} \
  ] $axi_intc_0


  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.CE_TYPE {HARDSYNC} \
    CONFIG.CLKOUT_DRIVES {MBUFGCE,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {625.000,100,300.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_USED {true,true,false,false,false,false,false} \
    CONFIG.JITTER_SEL {Min_O_Jitter} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.USE_PHASE_ALIGNMENT {true} \
  ] $clk_wizard_0


  # Create instance: ilconstant_2, and set properties
  set ilconstant_2 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 ilconstant_2 ]

  # Create instance: proc_sys_reset_o4, and set properties
  set proc_sys_reset_o4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_o4 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create interface connections
  connect_bd_intf_net -intf_net icn_ctrl_M00_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins ctrl_smc/M00_AXI]
  
  # Create port connections
  connect_bd_net -net clk_wizard_0_clk_out1_o4  [get_bd_pins clk_wizard_0/clk_out1_o4] \
  [get_bd_pins axi_intc_0/s_axi_aclk] \
  [get_bd_pins proc_sys_reset_o4/slowest_sync_clk] \
  [get_bd_pins ctrl_smc/aclk]
  connect_bd_net -net clk_wizard_0_clk_out2  [get_bd_pins clk_wizard_0/clk_out2] \
  [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_locked  [get_bd_pins clk_wizard_0/locked] \
  [get_bd_pins proc_sys_reset_o4/dcm_locked] \
  [get_bd_pins proc_sys_reset_1/dcm_locked]
  connect_bd_net -net ilconstant_2_dout  [get_bd_pins ilconstant_2/dout] \
  [get_bd_pins clk_wizard_0/clk_out1_clr_n] \
  [get_bd_pins clk_wizard_0/clk_out1_ce]
  connect_bd_net -net proc_sys_reset_o4_peripheral_aresetn  [get_bd_pins proc_sys_reset_o4/peripheral_aresetn] \
  [get_bd_pins axi_intc_0/s_axi_aresetn] \
  [get_bd_pins ctrl_smc/aresetn]
  connect_bd_net -net ps_wizard_0_pl0_resetn  [get_bd_pins clk_wizard_0/resetn] \
  [get_bd_pins proc_sys_reset_o4/ext_reset_in] \
  [get_bd_pins proc_sys_reset_1/ext_reset_in]

  connect_bd_net [get_bd_pins CIPS_0/pl0_ref_clk] [get_bd_pins clk_wizard_0/clk_in1]
  connect_bd_net [get_bd_pins CIPS_0/pl0_resetn] [get_bd_pins clk_wizard_0/resetn]
  connect_bd_net [get_bd_pins axi_intc_0/irq] [get_bd_pins CIPS_0/pl_ps_irq0]
  connect_bd_intf_net [get_bd_intf_pins CIPS_0/M_AXI_FPD] [get_bd_intf_pins ctrl_smc/S00_AXI]

  #connect clock input to fpd/lpd ports
  delete_bd_objs [get_bd_cells ilconstant_0]
  connect_bd_net [get_bd_pins CIPS_0/m_axi_fpd_aclk] [get_bd_pins clk_wizard_0/clk_out1_o4]
  
 #adddress mapping for interrupt controller
  assign_bd_address -target_address_space /CIPS_0/M_AXI_FPD [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  set_property offset 0xA4040000 [get_bd_addr_segs {CIPS_0/M_AXI_FPD/SEG_axi_intc_0_Reg}]

# Create PFM attributes
  set_property PFM_NAME {xilinx.com:vck190:versal_extensible_platform_base:1.0} [get_files [current_bd_design].bd]
  set_property PFM.AXI_PORT { M01_AXI {} M02_AXI {} M03_AXI {} M04_AXI {} M05_AXI {} M06_AXI {} M07_AXI {} M08_AXI {} M09_AXI {} M10_AXI {} M11_AXI {} M12_AXI {} M13_AXI {} M14_AXI {} M15_AXI {} } [get_bd_cells /ctrl_smc]
  set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells /axi_intc_0]
  set_property PFM.CLOCK {clk_out1_o1 {id "0" is_default false proc_sys_reset "/proc_sys_reset_o4" status "fixed_non_ref"} clk_out1_o2 {id "1" is_default true proc_sys_reset "/proc_sys_reset_o4" status "fixed_non_ref"} clk_out1_o3 {id "2" is_default false proc_sys_reset "/proc_sys_reset_o4" status "fixed_non_ref"} clk_out1_o4 {id "3" is_default false proc_sys_reset "/proc_sys_reset_o4" status "fixed_non_ref"} clk_out2 {id "4" is_default false proc_sys_reset "/proc_sys_reset_1" status "fixed"}} [get_bd_cells /clk_wizard_0]

  set_property PFM.AXI_PORT {S00_AXI {memport "S_AXI_NOC" sptag "DDR"} S01_AXI {memport "S_AXI_NOC" sptag "DDR"} S02_AXI {memport "S_AXI_NOC" sptag "DDR"} S03_AXI {memport "S_AXI_NOC" sptag "DDR"} S04_AXI {memport "S_AXI_NOC" sptag "DDR"} S05_AXI {memport "S_AXI_NOC" sptag "DDR"} S06_AXI {memport "S_AXI_NOC" sptag "DDR"} S07_AXI {memport "S_AXI_NOC" sptag "DDR"} S08_AXI {memport "S_AXI_NOC" sptag "DDR"} S09_AXI {memport "S_AXI_NOC" sptag "DDR"} S10_AXI {memport "S_AXI_NOC" sptag "DDR"} S11_AXI {memport "S_AXI_NOC" sptag "DDR"} S12_AXI {memport "S_AXI_NOC" sptag "DDR"} S13_AXI {memport "S_AXI_NOC" sptag "DDR"} S14_AXI {memport "S_AXI_NOC" sptag "DDR"} S15_AXI {memport "S_AXI_NOC" sptag "DDR"} S16_AXI {memport "S_AXI_NOC" sptag "DDR"} S17_AXI {memport "S_AXI_NOC" sptag "DDR"} S18_AXI {memport "S_AXI_NOC" sptag "DDR"} S19_AXI {memport "S_AXI_NOC" sptag "DDR"} S20_AXI {memport "S_AXI_NOC" sptag "DDR"} S21_AXI {memport "S_AXI_NOC" sptag "DDR"} S22_AXI {memport "S_AXI_NOC" sptag "DDR"} S23_AXI {memport "S_AXI_NOC" sptag "DDR"} S24_AXI {memport "S_AXI_NOC" sptag "DDR"} S25_AXI {memport "S_AXI_NOC" sptag "DDR"} S26_AXI {memport "S_AXI_NOC" sptag "DDR"} S27_AXI {memport "S_AXI_NOC" sptag "DDR"}} [get_bd_cells /noc_ddr]
  set_property PFM.AXI_PORT {S00_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S01_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S02_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S03_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S04_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S05_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S06_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S07_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S08_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S09_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S10_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S11_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S12_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S13_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S14_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S15_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S16_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S17_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S18_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S19_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S20_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S21_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S22_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S23_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S24_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S25_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S26_AXI {memport "S_AXI_NOC" sptag "LPDDR"} S27_AXI {memport "S_AXI_NOC" sptag "LPDDR"}} [get_bd_cells /noc_lpddr0]

  set_property PFM.AXI_PORT {S00_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S01_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S02_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S03_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S04_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S05_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S06_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S07_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S08_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S09_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S10_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S11_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S12_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S13_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S14_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S15_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S16_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S17_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S18_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S19_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S20_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S21_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S22_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S23_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S24_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S25_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S26_AXI {memport "S_AXI_NOC" sptag "LPDDR1"} S27_AXI {memport "S_AXI_NOC" sptag "LPDDR1"}} [get_bd_cells /noc_lpddr1]

#Platfrom Level Properties

set_property platform.extensible true [current_project]
set_property platform.design_intent.embedded true [current_project]

set_property platform.design_intent.server_managed false [current_project]
set_property platform.design_intent.external_host false [current_project]
set_property platform.design_intent.datacenter false [current_project]
set_property platform.uses_pr  "false" [current_project]
set_property platform.emu.dr_bd_inst_path {vitis_design_wrapper_sim_wrapper/vitis_design_wrapper_i/vitis_design_i} [current_project]

#setting Platform level param to have PDI in hw xsa
set_param platform.forceEnablePreSynthPDI true

validate_bd_design
save_bd_design
