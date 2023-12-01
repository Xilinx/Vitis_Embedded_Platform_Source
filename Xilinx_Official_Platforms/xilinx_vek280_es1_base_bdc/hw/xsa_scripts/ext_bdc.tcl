#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

# To test this script, run the following commands from Vivado Tcl console:
# source ext_bdc.tcl

# CHANGE DESIGN NAME HERE
variable design_name
set design_name ext_bdc

##################################################################
# DESIGN PROCs
##################################################################

# Hierarchical cell: axi_smc_vip_hier
proc create_hier_cell_axi_smc_vip_hier { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_axi_smc_vip_hier() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type clk clk_in1

  # Create instance: to_delete_kernel_ctrl_0, and set properties
  set to_delete_kernel_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 to_delete_kernel_ctrl_0 ]
  set_property CONFIG.INTERFACE_MODE {SLAVE} $to_delete_kernel_ctrl_0


  # Create instance: to_delete_kernel_ctrl_1, and set properties
  set to_delete_kernel_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 to_delete_kernel_ctrl_1 ]
  set_property CONFIG.INTERFACE_MODE {SLAVE} $to_delete_kernel_ctrl_1


  # Create instance: icn_ctrl, and set properties
  set icn_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 icn_ctrl ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {3} \
    CONFIG.NUM_SI {1} \
  ] $icn_ctrl


  # Create instance: icn_ctrl_0, and set properties
  set icn_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 icn_ctrl_0 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $icn_ctrl_0


  # Create instance: icn_ctrl_1, and set properties
  set icn_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 icn_ctrl_1 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $icn_ctrl_1


  # Create interface connections
  connect_bd_intf_net -intf_net CIPS_0_M_AXI_GP0 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins icn_ctrl/S00_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_0_M00_AXI [get_bd_intf_pins to_delete_kernel_ctrl_0/S_AXI] [get_bd_intf_pins icn_ctrl_0/M00_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_1_M00_AXI [get_bd_intf_pins to_delete_kernel_ctrl_1/S_AXI] [get_bd_intf_pins icn_ctrl_1/M00_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins icn_ctrl/M00_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_M01_AXI [get_bd_intf_pins icn_ctrl/M01_AXI] [get_bd_intf_pins icn_ctrl_0/S00_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_M02_AXI [get_bd_intf_pins icn_ctrl/M02_AXI] [get_bd_intf_pins icn_ctrl_1/S00_AXI]

  # Create port connections
  connect_bd_net -net clk_in1_1 [get_bd_pins clk_in1] [get_bd_pins icn_ctrl/aclk]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins aclk] [get_bd_pins to_delete_kernel_ctrl_1/aclk] [get_bd_pins to_delete_kernel_ctrl_0/aclk] [get_bd_pins icn_ctrl/aclk1] [get_bd_pins icn_ctrl_0/aclk] [get_bd_pins icn_ctrl_1/aclk]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins to_delete_kernel_ctrl_1/aresetn] [get_bd_pins to_delete_kernel_ctrl_0/aresetn] [get_bd_pins icn_ctrl/aresetn] [get_bd_pins icn_ctrl_0/aresetn] [get_bd_pins icn_ctrl_1/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set S00_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {44} \
   CONFIG.ARUSER_WIDTH {16} \
   CONFIG.AWUSER_WIDTH {16} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {16} \
   CONFIG.MAX_BURST_LENGTH {256} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $S00_AXI
  set_property APERTURES {{0xA400_0000 144M}} [get_bd_intf_ports S00_AXI]

  set S00_INI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:inimm_rtl:1.0 S00_INI ]
  set_property -dict [ list \
   CONFIG.COMPUTED_STRATEGY {load} \
   CONFIG.INI_STRATEGY {load} \
   ] $S00_INI

  set M02_INI_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M02_INI_0 ]
  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   ] $M02_INI_0
  set_property APERTURES {{0x0 2G} {0x8_0000_0000 2G}} [get_bd_intf_ports M02_INI_0]

  set M01_INI_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M01_INI_0 ]
  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   ] $M01_INI_0
  set_property APERTURES {{0x0 2G} {0x8_0000_0000 2G}} [get_bd_intf_ports M01_INI_0]

  set M00_INI_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M00_INI_0 ]
  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   ] $M00_INI_0
  set_property APERTURES {{0x0 2G} {0x8_0000_0000 2G}} [get_bd_intf_ports M00_INI_0]

  set M03_INI_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M03_INI_0 ]
  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   ] $M03_INI_0
  set_property APERTURES {{0x0 2G} {0x8_0000_0000 2G}} [get_bd_intf_ports M03_INI_0]

  set M00_INI_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M00_INI_1 ]
  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   ] $M00_INI_1
  set_property APERTURES {{0x500_0000_0000 8G}} [get_bd_intf_ports M00_INI_1]

  set M03_INI_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M03_INI_1 ]
  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   ] $M03_INI_1
  set_property APERTURES {{0x500_0000_0000 8G}} [get_bd_intf_ports M03_INI_1]

  set M01_INI_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M01_INI_1 ]
  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   ] $M01_INI_1
  set_property APERTURES {{0x500_0000_0000 8G}} [get_bd_intf_ports M01_INI_1]

  set M02_INI_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:inimm_rtl:1.0 M02_INI_1 ]
  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   ] $M02_INI_1
  set_property APERTURES {{0x500_0000_0000 8G}} [get_bd_intf_ports M02_INI_1]


  # Create ports
  set clk_in1 [ create_bd_port -dir I -type clk clk_in1 ]
  set_property -dict [ list \
   CONFIG.FREQ_TOLERANCE_HZ {1} \
 ] $clk_in1
  set ext_reset_in [ create_bd_port -dir I -type rst ext_reset_in ]
  set irq [ create_bd_port -dir O -type intr irq ]

  # Create instance: ConfigNoc, and set properties
  set ConfigNoc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 ConfigNoc ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {1} \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_NSI {1} \
    CONFIG.NUM_SI {0} \
  ] $ConfigNoc


  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /ConfigNoc/M00_AXI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M00_AXI {read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}}} \
 ] [get_bd_intf_pins /ConfigNoc/S00_INI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI} \
 ] [get_bd_pins /ConfigNoc/aclk0]

  # Create instance: ai_engine_0, and set properties
  set ai_engine_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ai_engine:2.0 ai_engine_0 ]
  set_property -dict [list \
    CONFIG.CLK_NAMES {} \
    CONFIG.NAME_MI_AXI {} \
    CONFIG.NAME_MI_AXIS {} \
    CONFIG.NAME_SI_AXI {S00_AXI,} \
    CONFIG.NAME_SI_AXIS {} \
    CONFIG.NUM_CLKS {0} \
    CONFIG.NUM_MI_AXI {0} \
    CONFIG.NUM_MI_AXIS {0} \
    CONFIG.NUM_SI_AXI {1} \
    CONFIG.NUM_SI_AXIS {0} \
  ] $ai_engine_0


  set_property -dict [ list \
   CONFIG.CATEGORY {NOC} \
 ] [get_bd_intf_pins /ai_engine_0/S00_AXI]

  # Create instance: aggr_noc, and set properties
  set aggr_noc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 aggr_noc ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {0} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NMI {8} \
    CONFIG.NUM_SI {0} \
  ] $aggr_noc


  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /aggr_noc/M00_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /aggr_noc/M01_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /aggr_noc/M02_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /aggr_noc/M03_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /aggr_noc/M04_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /aggr_noc/M05_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /aggr_noc/M06_INI]

  # Create instance: LPDDRNoc0, and set properties
  set LPDDRNoc0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 LPDDRNoc0 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {0} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NMI {4} \
    CONFIG.NUM_NSI {4} \
    CONFIG.NUM_SI {0} \
  ] $LPDDRNoc0


  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /LPDDRNoc0/M00_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /LPDDRNoc0/M01_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /LPDDRNoc0/M02_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /LPDDRNoc0/M03_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M00_INI {read_bw {0} write_bw {0}}} \
 ] [get_bd_intf_pins /LPDDRNoc0/S00_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M01_INI {read_bw {0} write_bw {0}}} \
 ] [get_bd_intf_pins /LPDDRNoc0/S01_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M02_INI {read_bw {0} write_bw {0}}} \
 ] [get_bd_intf_pins /LPDDRNoc0/S02_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M03_INI {read_bw {0} write_bw {0}}} \
 ] [get_bd_intf_pins /LPDDRNoc0/S03_INI]

  # Create instance: LPDDRNoc1, and set properties
  set LPDDRNoc1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 LPDDRNoc1 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {0} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NMI {4} \
    CONFIG.NUM_NSI {4} \
    CONFIG.NUM_SI {0} \
  ] $LPDDRNoc1


  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /LPDDRNoc1/M00_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /LPDDRNoc1/M01_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /LPDDRNoc1/M02_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
 ] [get_bd_intf_pins /LPDDRNoc1/M03_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M00_INI {read_bw {0} write_bw {0}}} \
 ] [get_bd_intf_pins /LPDDRNoc1/S00_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M01_INI {read_bw {0} write_bw {0}}} \
 ] [get_bd_intf_pins /LPDDRNoc1/S01_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M02_INI {read_bw {0} write_bw {0}}} \
 ] [get_bd_intf_pins /LPDDRNoc1/S02_INI]

  set_property -dict [ list \
   CONFIG.INI_STRATEGY {load} \
   CONFIG.CONNECTIONS {M03_INI {read_bw {0} write_bw {0}}} \
 ] [get_bd_intf_pins /LPDDRNoc1/S03_INI]

  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 clk_wizard_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
    CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
    CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
    CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
    CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {100.000,150.000,300.000,75.000,200.000,400.000,600.000} \
    CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
    CONFIG.CLKOUT_USED {true,true,true,true,true,true,true} \
    CONFIG.JITTER_SEL {Min_O_Jitter} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_PHASE_ALIGNMENT {true} \
    CONFIG.USE_RESET {true} \
  ] $clk_wizard_0


  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]
  set_property -dict [list \
    CONFIG.C_ASYNC_INTR {0xFFFFFFFF} \
    CONFIG.C_IRQ_CONNECTION {1} \
  ] $axi_intc_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: proc_sys_reset_2, and set properties
  set proc_sys_reset_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_2 ]

  # Create instance: proc_sys_reset_3, and set properties
  set proc_sys_reset_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_3 ]

  # Create instance: proc_sys_reset_4, and set properties
  set proc_sys_reset_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_4 ]

  # Create instance: proc_sys_reset_5, and set properties
  set proc_sys_reset_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_5 ]

  # Create instance: proc_sys_reset_6, and set properties
  set proc_sys_reset_6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_6 ]

  # Create instance: axi_smc_vip_hier
  create_hier_cell_axi_smc_vip_hier [current_bd_instance .] axi_smc_vip_hier

  # Create interface connections
  connect_bd_intf_net -intf_net CIPS_0_M_AXI_GP0 [get_bd_intf_ports S00_AXI] [get_bd_intf_pins axi_smc_vip_hier/S00_AXI]
  connect_bd_intf_net -intf_net ConfigNoc_M00_AXI [get_bd_intf_pins ConfigNoc/M00_AXI] [get_bd_intf_pins ai_engine_0/S00_AXI]
  connect_bd_intf_net -intf_net LPDDRNoc0_M00_INI [get_bd_intf_ports M00_INI_0] [get_bd_intf_pins LPDDRNoc0/M00_INI]
  connect_bd_intf_net -intf_net LPDDRNoc0_M01_INI [get_bd_intf_ports M01_INI_0] [get_bd_intf_pins LPDDRNoc0/M01_INI]
  connect_bd_intf_net -intf_net LPDDRNoc0_M02_INI [get_bd_intf_ports M02_INI_0] [get_bd_intf_pins LPDDRNoc0/M02_INI]
  connect_bd_intf_net -intf_net LPDDRNoc0_M03_INI [get_bd_intf_ports M03_INI_0] [get_bd_intf_pins LPDDRNoc0/M03_INI]
  connect_bd_intf_net -intf_net LPDDRNoc1_M00_INI [get_bd_intf_ports M00_INI_1] [get_bd_intf_pins LPDDRNoc1/M00_INI]
  connect_bd_intf_net -intf_net LPDDRNoc1_M01_INI [get_bd_intf_ports M01_INI_1] [get_bd_intf_pins LPDDRNoc1/M01_INI]
  connect_bd_intf_net -intf_net LPDDRNoc1_M02_INI [get_bd_intf_ports M02_INI_1] [get_bd_intf_pins LPDDRNoc1/M02_INI]
  connect_bd_intf_net -intf_net LPDDRNoc1_M03_INI [get_bd_intf_ports M03_INI_1] [get_bd_intf_pins LPDDRNoc1/M03_INI]
  connect_bd_intf_net -intf_net aggr_noc_M00_INI [get_bd_intf_pins aggr_noc/M00_INI] [get_bd_intf_pins LPDDRNoc0/S00_INI]
  connect_bd_intf_net -intf_net aggr_noc_M01_INI [get_bd_intf_pins aggr_noc/M01_INI] [get_bd_intf_pins LPDDRNoc0/S01_INI]
  connect_bd_intf_net -intf_net aggr_noc_M02_INI [get_bd_intf_pins aggr_noc/M02_INI] [get_bd_intf_pins LPDDRNoc0/S02_INI]
  connect_bd_intf_net -intf_net aggr_noc_M03_INI [get_bd_intf_pins aggr_noc/M03_INI] [get_bd_intf_pins LPDDRNoc0/S03_INI]
  connect_bd_intf_net -intf_net aggr_noc_M04_INI [get_bd_intf_pins aggr_noc/M04_INI] [get_bd_intf_pins LPDDRNoc1/S00_INI]
  connect_bd_intf_net -intf_net aggr_noc_M05_INI [get_bd_intf_pins aggr_noc/M05_INI] [get_bd_intf_pins LPDDRNoc1/S01_INI]
  connect_bd_intf_net -intf_net aggr_noc_M06_INI [get_bd_intf_pins aggr_noc/M06_INI] [get_bd_intf_pins LPDDRNoc1/S02_INI]
  connect_bd_intf_net -intf_net aggr_noc_M07_INI [get_bd_intf_pins aggr_noc/M07_INI] [get_bd_intf_pins LPDDRNoc1/S03_INI]
  connect_bd_intf_net -intf_net cips_noc_M08_INI [get_bd_intf_ports S00_INI] [get_bd_intf_pins ConfigNoc/S00_INI]
  connect_bd_intf_net -intf_net icn_ctrl_M00_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins axi_smc_vip_hier/M00_AXI]

  # Create port connections
  connect_bd_net -net CIPS_0_pl_resetn1 [get_bd_ports ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins proc_sys_reset_1/ext_reset_in] [get_bd_pins proc_sys_reset_2/ext_reset_in] [get_bd_pins proc_sys_reset_3/ext_reset_in] [get_bd_pins proc_sys_reset_4/ext_reset_in] [get_bd_pins proc_sys_reset_5/ext_reset_in] [get_bd_pins proc_sys_reset_6/ext_reset_in] [get_bd_pins clk_wizard_0/resetn]
  connect_bd_net -net ai_engine_0_s00_axi_aclk [get_bd_pins ai_engine_0/s00_axi_aclk] [get_bd_pins ConfigNoc/aclk0]
  connect_bd_net -net axi_intc_0_irq [get_bd_pins axi_intc_0/irq] [get_bd_ports irq]
  connect_bd_net -net clk_in1_1 [get_bd_ports clk_in1] [get_bd_pins clk_wizard_0/clk_in1] [get_bd_pins axi_smc_vip_hier/clk_in1]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins axi_smc_vip_hier/aclk]
  connect_bd_net -net clk_wizard_0_clk_out2 [get_bd_pins clk_wizard_0/clk_out2] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out3 [get_bd_pins clk_wizard_0/clk_out3] [get_bd_pins proc_sys_reset_2/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out4 [get_bd_pins clk_wizard_0/clk_out4] [get_bd_pins proc_sys_reset_3/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out5 [get_bd_pins clk_wizard_0/clk_out5] [get_bd_pins proc_sys_reset_4/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out6 [get_bd_pins clk_wizard_0/clk_out6] [get_bd_pins proc_sys_reset_5/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out7 [get_bd_pins clk_wizard_0/clk_out7] [get_bd_pins proc_sys_reset_6/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_locked [get_bd_pins clk_wizard_0/locked] [get_bd_pins proc_sys_reset_0/dcm_locked] [get_bd_pins proc_sys_reset_1/dcm_locked] [get_bd_pins proc_sys_reset_2/dcm_locked] [get_bd_pins proc_sys_reset_3/dcm_locked] [get_bd_pins proc_sys_reset_4/dcm_locked] [get_bd_pins proc_sys_reset_5/dcm_locked] [get_bd_pins proc_sys_reset_6/dcm_locked]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins axi_smc_vip_hier/aresetn]

  # Create address segments
  assign_bd_address -offset 0xA4020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axi_intc_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axi_smc_vip_hier/to_delete_kernel_ctrl_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xA4010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces S00_AXI] [get_bd_addr_segs axi_smc_vip_hier/to_delete_kernel_ctrl_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces S00_INI] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""




