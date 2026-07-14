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

#enable segmented configuration
  set_property segmented_configuration true [current_project]

#delete unwanted connections and IPs
  disconnect_bd_net /ilconstant_0_dout [get_bd_pins ps_wizard_0/fpd_axi_pl_aclk]
  disconnect_bd_net /ilconstant_0_dout [get_bd_pins ps_wizard_0/lpd_axi_pl_aclk]
  delete_bd_objs [get_bd_nets ilconstant_0_dout] [get_bd_cells ilconstant_0]

# Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property -dict [list \
    CONFIG.C_ASYNC_INTR {0xFFFFFFFF} \
    CONFIG.C_IRQ_CONNECTION {1} \
  ] $axi_intc_0


  # Create instance: ctrl_smc, and set properties
  set ctrl_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 ctrl_smc ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $ctrl_smc


  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clkx5_wiz:1.0 clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.CE_TYPE {HARDSYNC} \
    CONFIG.CLKOUT_DRIVES {MBUFGCE,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_GROUPING {Auto,Auto,Auto,Auto,Auto,Auto,Auto} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {625,100,100.000,100.000,100.000,100.000,100.000} \
    CONFIG.CLKOUT_USED {true,true,false,false,false,false,false} \
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
  [get_bd_pins clk_wizard_0/clk_out1_ce] \
  [get_bd_pins clk_wizard_0/clk_out1_clr_n]
  connect_bd_net -net proc_sys_reset_o4_peripheral_aresetn  [get_bd_pins proc_sys_reset_o4/peripheral_aresetn] \
  [get_bd_pins axi_intc_0/s_axi_aresetn] \
  [get_bd_pins ctrl_smc/aresetn]
  connect_bd_net -net ps_wizard_0_pl0_resetn  [get_bd_pins proc_sys_reset_o4/ext_reset_in] \
  [get_bd_pins proc_sys_reset_1/ext_reset_in] \
  [get_bd_pins clk_wizard_0/resetn]

  connect_bd_net [get_bd_pins axi_intc_0/irq] [get_bd_pins ps_wizard_0/pl_ps_irq0]
  connect_bd_intf_net [get_bd_intf_pins ctrl_smc/M00_AXI] [get_bd_intf_pins axi_intc_0/s_axi]
  connect_bd_net [get_bd_pins ps_wizard_0/fpd_axi_pl_aclk] [get_bd_pins ps_wizard_0/lpd_axi_pl_aclk]
  connect_bd_net [get_bd_pins ps_wizard_0/lpd_axi_pl_aclk] [get_bd_pins clk_wizard_0/clk_out1_o4]
  connect_bd_net [get_bd_pins clk_wizard_0/clk_in1] [get_bd_pins ps_wizard_0/pl0_ref_clk]
  set_property location {7 2106 614} [get_bd_cells ps_wizard_0]
  connect_bd_net [get_bd_pins ps_wizard_0/pl0_resetn] [get_bd_pins proc_sys_reset_o4/ext_reset_in]
  set_property location {6.5 2479 509} [get_bd_cells ps_wizard_0]
  connect_bd_intf_net [get_bd_intf_pins ps_wizard_0/FPD_AXI_PL] [get_bd_intf_pins ctrl_smc/S00_AXI]
  

   #add address editor
  assign_bd_address

  # Create PFM attributes
  set_property PFM_NAME {xilinx.com:vrk160:vrk160_base:1.0} [get_files [current_bd_design].bd]
  set_property PFM.AXI_PORT { S00_AXI {sptag LPDDR0 auto false} S01_AXI {sptag LPDDR0 auto false} S02_AXI {sptag LPDDR0 auto false} S03_AXI {sptag LPDDR0 auto false} S04_AXI {sptag LPDDR0 auto false} S05_AXI {sptag LPDDR0 auto false} S06_AXI {sptag LPDDR0 auto false} S07_AXI {sptag LPDDR0 auto false} S08_AXI {sptag LPDDR0 auto false} S09_AXI {sptag LPDDR0 auto false} S10_AXI {sptag LPDDR0 auto false} S11_AXI {sptag LPDDR0 auto false} S12_AXI {sptag LPDDR0 auto false} S13_AXI {sptag LPDDR0 auto false} S14_AXI {sptag LPDDR0 auto false} S15_AXI {sptag LPDDR0 auto false} S16_AXI {sptag LPDDR0 auto false} S17_AXI {sptag LPDDR0 auto false} S18_AXI {sptag LPDDR0 auto false} S19_AXI {sptag LPDDR0 auto false} } [get_bd_cells /NoC_C0]
  set_property PFM.AXI_PORT { S00_AXI {sptag LPDDR1} S01_AXI {sptag LPDDR1} S02_AXI {sptag LPDDR1} S03_AXI {sptag LPDDR1} S04_AXI {sptag LPDDR1} S05_AXI {sptag LPDDR1} S06_AXI {sptag LPDDR1} S07_AXI {sptag LPDDR1} S08_AXI {sptag LPDDR1} S09_AXI {sptag LPDDR1} S10_AXI {sptag LPDDR1} S11_AXI {sptag LPDDR1} S12_AXI {sptag LPDDR1} S13_AXI {sptag LPDDR1} S14_AXI {sptag LPDDR1} S15_AXI {sptag LPDDR1} S16_AXI {sptag LPDDR1} S17_AXI {sptag LPDDR1} S18_AXI {sptag LPDDR1} S19_AXI {sptag LPDDR1} S20_AXI {sptag LPDDR1} S21_AXI {sptag LPDDR1} S22_AXI {sptag LPDDR1} S23_AXI {sptag LPDDR1} S24_AXI {sptag LPDDR1} S25_AXI {sptag LPDDR1} S26_AXI {sptag LPDDR1} S27_AXI {sptag LPDDR1} S28_AXI {sptag LPDDR1} S29_AXI {sptag LPDDR1} S30_AXI {sptag LPDDR1} S31_AXI {sptag LPDDR1} S32_AXI {sptag LPDDR1} S33_AXI {sptag LPDDR1} S34_AXI {sptag LPDDR1} S35_AXI {sptag LPDDR1} S36_AXI {sptag LPDDR1} S37_AXI {sptag LPDDR1} } [get_bd_cells /NoC_C1]
  set_property PFM.AXI_PORT { S00_AXI {sptag LPDDR2} S01_AXI {sptag LPDDR2} S02_AXI {sptag LPDDR2} S03_AXI {sptag LPDDR2} S04_AXI {sptag LPDDR2} S05_AXI {sptag LPDDR2} S06_AXI {sptag LPDDR2} S07_AXI {sptag LPDDR2} S08_AXI {sptag LPDDR2} S09_AXI {sptag LPDDR2} S10_AXI {sptag LPDDR2} S11_AXI {sptag LPDDR2} S12_AXI {sptag LPDDR2} S13_AXI {sptag LPDDR2} S14_AXI {sptag LPDDR2} S15_AXI {sptag LPDDR2} S16_AXI {sptag LPDDR2} S17_AXI {sptag LPDDR2} S18_AXI {sptag LPDDR2} S19_AXI {sptag LPDDR2} S20_AXI {sptag LPDDR2} S21_AXI {sptag LPDDR2} S22_AXI {sptag LPDDR2} S23_AXI {sptag LPDDR2} S24_AXI {sptag LPDDR2} S25_AXI {sptag LPDDR2} S26_AXI {sptag LPDDR2} S27_AXI {sptag LPDDR2} S28_AXI {sptag LPDDR2} S29_AXI {sptag LPDDR2} S30_AXI {sptag LPDDR2} S31_AXI {sptag LPDDR2} S32_AXI {sptag LPDDR2} S33_AXI {sptag LPDDR2} S34_AXI {sptag LPDDR2} S35_AXI {sptag LPDDR2} S36_AXI {sptag LPDDR2} S37_AXI {sptag LPDDR2} } [get_bd_cells /NoC_C2]
  set_property PFM.AXI_PORT { S00_AXI {sptag LPDDR3} S01_AXI {sptag LPDDR3} S02_AXI {sptag LPDDR3} S03_AXI {sptag LPDDR3} S04_AXI {sptag LPDDR3} S05_AXI {sptag LPDDR3} S06_AXI {sptag LPDDR3} S07_AXI {sptag LPDDR3} S08_AXI {sptag LPDDR3} S09_AXI {sptag LPDDR3} S10_AXI {sptag LPDDR3} S11_AXI {sptag LPDDR3} S12_AXI {sptag LPDDR3} S13_AXI {sptag LPDDR3} S14_AXI {sptag LPDDR3} S15_AXI {sptag LPDDR3} S16_AXI {sptag LPDDR3} S17_AXI {sptag LPDDR3} S18_AXI {sptag LPDDR3} S19_AXI {sptag LPDDR3} S20_AXI {sptag LPDDR3} S21_AXI {sptag LPDDR3} S22_AXI {sptag LPDDR3} S23_AXI {sptag LPDDR3} S24_AXI {sptag LPDDR3} S25_AXI {sptag LPDDR3} S26_AXI {sptag LPDDR3} S27_AXI {sptag LPDDR3} S28_AXI {sptag LPDDR3} S29_AXI {sptag LPDDR3} S30_AXI {sptag LPDDR3} S31_AXI {sptag LPDDR3} S32_AXI {sptag LPDDR3} S33_AXI {sptag LPDDR3} S34_AXI {sptag LPDDR3} S35_AXI {sptag LPDDR3} S36_AXI {sptag LPDDR3} S37_AXI {sptag LPDDR3} } [get_bd_cells /NoC_C3]
  set_property PFM.AXI_PORT { S00_AXI {sptag LPDDR auto preferred} S01_AXI {sptag LPDDR auto preferred} S02_AXI {sptag LPDDR auto preferred} S03_AXI {sptag LPDDR auto preferred} S04_AXI {sptag LPDDR auto preferred} S05_AXI {sptag LPDDR auto preferred} S06_AXI {sptag LPDDR auto preferred} S07_AXI {sptag LPDDR auto preferred} S08_AXI {sptag LPDDR auto preferred} S09_AXI {sptag LPDDR auto preferred} S10_AXI {sptag LPDDR auto preferred} S11_AXI {sptag LPDDR auto preferred} S12_AXI {sptag LPDDR auto preferred} S13_AXI {sptag LPDDR auto preferred} S14_AXI {sptag LPDDR auto preferred} S15_AXI {sptag LPDDR auto preferred} S16_AXI {sptag LPDDR auto preferred} S17_AXI {sptag LPDDR auto preferred} S18_AXI {sptag LPDDR auto preferred} S19_AXI {sptag LPDDR auto preferred} S20_AXI {sptag LPDDR auto preferred} S21_AXI {sptag LPDDR auto preferred} S22_AXI {sptag LPDDR auto preferred} S23_AXI {sptag LPDDR auto preferred} S24_AXI {sptag LPDDR auto preferred} S25_AXI {sptag LPDDR auto preferred} S26_AXI {sptag LPDDR auto preferred} S27_AXI {sptag LPDDR auto preferred} S28_AXI {sptag LPDDR auto preferred} S29_AXI {sptag LPDDR auto preferred} S30_AXI {sptag LPDDR auto preferred} S31_AXI {sptag LPDDR auto preferred} S32_AXI {sptag LPDDR auto preferred} S33_AXI {sptag LPDDR auto preferred} S34_AXI {sptag LPDDR auto preferred} S35_AXI {sptag LPDDR auto preferred} S36_AXI {sptag LPDDR auto preferred} S37_AXI {sptag LPDDR auto preferred} } [get_bd_cells /aggr_noc]
  set_property PFM.AXI_PORT { S00_AXI {sptag AIE auto false} S01_AXI {sptag AIE auto false} S02_AXI {sptag AIE auto false} S03_AXI {sptag AIE auto false} S04_AXI {sptag AIE auto false} S05_AXI {sptag AIE auto false} S06_AXI {sptag AIE auto false} S07_AXI {sptag AIE auto false} S08_AXI {sptag AIE auto false} S09_AXI {sptag AIE auto false} S10_AXI {sptag AIE auto false} S11_AXI {sptag AIE auto false} S12_AXI {sptag AIE auto false} S13_AXI {sptag AIE auto false} S14_AXI {sptag AIE auto false} S15_AXI {sptag AIE auto false} } [get_bd_cells /ConfigNoc]
  set_property PFM.CLOCK {clk_out1_o1 {id "0" is_default false proc_sys_reset "/proc_sys_reset_o4" status "fixed_non_ref"} clk_out1_o2 {id "1" is_default true proc_sys_reset "/proc_sys_reset_o4" status "fixed_non_ref"} clk_out1_o3 {id "2" is_default false proc_sys_reset "/proc_sys_reset_o4" status "fixed_non_ref"} clk_out1_o4 {id "3" is_default false proc_sys_reset "/proc_sys_reset_o4" status "fixed_non_ref"} clk_out2 {id "4" is_default false proc_sys_reset "/proc_sys_reset_1" status "fixed"}} [get_bd_cells /clk_wizard_0]
  set_property PFM.AXI_PORT { M01_AXI {} M02_AXI {} M03_AXI {} M04_AXI {} M05_AXI {} M06_AXI {} M07_AXI {} M08_AXI {} M09_AXI {} M10_AXI {} M11_AXI {} M12_AXI {} M13_AXI {} M14_AXI {} M15_AXI {} } [get_bd_cells /ctrl_smc]
  set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells /axi_intc_0]
  
  #Platform Level Properties 
  set_property platform.design_intent.embedded "true" [current_project]
  set_property platform.design_intent.server_managed "false" [current_project]
  set_property platform.design_intent.external_host "false" [current_project]
  set_property platform.design_intent.datacenter "false" [current_project]
  set_property platform.uses_pr  "false" [current_project]
  set_property platform.extensible true [current_project]
  set_property platform.emu.dr_bd_inst_path {vitis_design_wrapper_sim_wrapper/vitis_design_wrapper_i/vitis_design_i} [current_project]
  
  save_bd_design
  validate_bd_design



