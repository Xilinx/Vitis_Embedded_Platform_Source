##################################################################
# DESIGN PROCs
##################################################################

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
  set CH0_DDR4_0_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_dimm1 ]

  set sys_clk0_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_dimm1_sma_clk ]

  set ch0_lpddr4_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_c0 ]

  set ch0_lpddr4_c1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch0_lpddr4_c1 ]

  set ch1_lpddr4_c0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_c0 ]

  set ch1_lpddr4_c1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:lpddr4_rtl:1.0 ch1_lpddr4_c1 ]

  set lpddr4_sma_clk1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_sma_clk1 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $lpddr4_sma_clk1

  set lpddr4_sma_clk2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 lpddr4_sma_clk2 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $lpddr4_sma_clk2

   set_property CONFIG.FREQ_HZ 200000000 [get_bd_intf_ports /ddr4_dimm1_sma_clk]
 
  # Create ports

  # Create instance: CIPS_0, and set properties
  set CIPS_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:versal_cips CIPS_0 ]
  set_property -dict [ list \
   CONFIG.CPM_PCIE0_EXT_PCIE_CFG_SPACE_ENABLED {None} \
   CONFIG.CPM_PCIE0_MODES {None} \
   CONFIG.CPM_PCIE1_EXT_PCIE_CFG_SPACE_ENABLED {None} \
   CONFIG.PMC_CRP_CFU_REF_CTRL_ACT_FREQMHZ {299.997009} \
   CONFIG.PMC_CRP_CFU_REF_CTRL_DIVISOR0 {4} \
   CONFIG.PMC_CRP_CFU_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_DFT_OSC_REF_CTRL_DIVISOR0 {3} \
   CONFIG.PMC_CRP_DFT_OSC_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_HSM0_REF_CTRL_DIVISOR0 {36} \
   CONFIG.PMC_CRP_HSM0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_HSM1_REF_CTRL_DIVISOR0 {9} \
   CONFIG.PMC_CRP_HSM1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_I2C_REF_CTRL_DIVISOR0 {12} \
   CONFIG.PMC_CRP_I2C_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_LSBUS_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PMC_CRP_LSBUS_REF_CTRL_DIVISOR0 {12} \
   CONFIG.PMC_CRP_LSBUS_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_NOC_REF_CTRL_ACT_FREQMHZ {949.990479} \
   CONFIG.PMC_CRP_NOC_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PMC_CRP_NPI_REF_CTRL_DIVISOR0 {4} \
   CONFIG.PMC_CRP_NPI_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_NPLL_CTRL_CLKOUTDIV {4} \
   CONFIG.PMC_CRP_NPLL_CTRL_FBDIV {114} \
   CONFIG.PMC_CRP_NPLL_CTRL_SRCSEL {REF_CLK} \
   CONFIG.PMC_CRP_NPLL_TO_XPD_CTRL_DIVISOR0 {1} \
   CONFIG.PMC_CRP_OSPI_REF_CTRL_DIVISOR0 {4} \
   CONFIG.PMC_CRP_OSPI_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_PL0_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PMC_CRP_PL0_REF_CTRL_DIVISOR0 {12} \
   CONFIG.PMC_CRP_PL0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_PL1_REF_CTRL_DIVISOR0 {3} \
   CONFIG.PMC_CRP_PL1_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PMC_CRP_PL2_REF_CTRL_DIVISOR0 {3} \
   CONFIG.PMC_CRP_PL2_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PMC_CRP_PL3_REF_CTRL_DIVISOR0 {3} \
   CONFIG.PMC_CRP_PL3_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PMC_CRP_PPLL_CTRL_CLKOUTDIV {2} \
   CONFIG.PMC_CRP_PPLL_CTRL_FBDIV {72} \
   CONFIG.PMC_CRP_PPLL_CTRL_SRCSEL {REF_CLK} \
   CONFIG.PMC_CRP_PPLL_TO_XPD_CTRL_DIVISOR0 {2} \
   CONFIG.PMC_CRP_QSPI_REF_CTRL_ACT_FREQMHZ {199.998001} \
   CONFIG.PMC_CRP_QSPI_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PMC_CRP_QSPI_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_SDIO0_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PMC_CRP_SDIO0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_SDIO1_REF_CTRL_ACT_FREQMHZ {199.998001} \
   CONFIG.PMC_CRP_SDIO1_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PMC_CRP_SDIO1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_SD_DLL_REF_CTRL_ACT_FREQMHZ {1199.988037} \
   CONFIG.PMC_CRP_SD_DLL_REF_CTRL_DIVISOR0 {1} \
   CONFIG.PMC_CRP_SD_DLL_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_CRP_TEST_PATTERN_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PMC_CRP_TEST_PATTERN_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PMC_GPIO0_MIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_GPIO1_MIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_HSM0_CLOCK_ENABLE {1} \
   CONFIG.PMC_HSM1_CLOCK_ENABLE {1} \
   CONFIG.PMC_MIO_0_DIRECTION {out} \
   CONFIG.PMC_MIO_0_SCHMITT {1} \
   CONFIG.PMC_MIO_10_DIRECTION {inout} \
   CONFIG.PMC_MIO_11_DIRECTION {inout} \
   CONFIG.PMC_MIO_12_DIRECTION {out} \
   CONFIG.PMC_MIO_12_SCHMITT {1} \
   CONFIG.PMC_MIO_13_DIRECTION {out} \
   CONFIG.PMC_MIO_13_SCHMITT {1} \
   CONFIG.PMC_MIO_14_DIRECTION {inout} \
   CONFIG.PMC_MIO_15_DIRECTION {inout} \
   CONFIG.PMC_MIO_16_DIRECTION {inout} \
   CONFIG.PMC_MIO_17_DIRECTION {inout} \
   CONFIG.PMC_MIO_19_DIRECTION {inout} \
   CONFIG.PMC_MIO_1_DIRECTION {inout} \
   CONFIG.PMC_MIO_20_DIRECTION {inout} \
   CONFIG.PMC_MIO_21_DIRECTION {inout} \
   CONFIG.PMC_MIO_22_DIRECTION {inout} \
   CONFIG.PMC_MIO_24_DIRECTION {out} \
   CONFIG.PMC_MIO_24_SCHMITT {1} \
   CONFIG.PMC_MIO_26_DIRECTION {inout} \
   CONFIG.PMC_MIO_27_DIRECTION {inout} \
   CONFIG.PMC_MIO_29_DIRECTION {inout} \
   CONFIG.PMC_MIO_2_DIRECTION {inout} \
   CONFIG.PMC_MIO_30_DIRECTION {inout} \
   CONFIG.PMC_MIO_31_DIRECTION {inout} \
   CONFIG.PMC_MIO_32_DIRECTION {inout} \
   CONFIG.PMC_MIO_33_DIRECTION {inout} \
   CONFIG.PMC_MIO_34_DIRECTION {inout} \
   CONFIG.PMC_MIO_35_DIRECTION {inout} \
   CONFIG.PMC_MIO_36_DIRECTION {inout} \
   CONFIG.PMC_MIO_37_DIRECTION {out} \
   CONFIG.PMC_MIO_37_OUTPUT_DATA {high} \
   CONFIG.PMC_MIO_37_PULL {pulldown} \
   CONFIG.PMC_MIO_37_USAGE {GPIO} \
   CONFIG.PMC_MIO_3_DIRECTION {inout} \
   CONFIG.PMC_MIO_40_DIRECTION {out} \
   CONFIG.PMC_MIO_40_SCHMITT {1} \
   CONFIG.PMC_MIO_43_DIRECTION {out} \
   CONFIG.PMC_MIO_43_SCHMITT {1} \
   CONFIG.PMC_MIO_44_DIRECTION {inout} \
   CONFIG.PMC_MIO_45_DIRECTION {inout} \
   CONFIG.PMC_MIO_46_DIRECTION {inout} \
   CONFIG.PMC_MIO_47_DIRECTION {inout} \
   CONFIG.PMC_MIO_48_DIRECTION {out} \
   CONFIG.PMC_MIO_48_PULL {pullup} \
   CONFIG.PMC_MIO_48_USAGE {GPIO} \
   CONFIG.PMC_MIO_49_DIRECTION {out} \
   CONFIG.PMC_MIO_49_PULL {pullup} \
   CONFIG.PMC_MIO_49_USAGE {GPIO} \
   CONFIG.PMC_MIO_4_DIRECTION {inout} \
   CONFIG.PMC_MIO_51_DIRECTION {out} \
   CONFIG.PMC_MIO_51_SCHMITT {1} \
   CONFIG.PMC_MIO_5_DIRECTION {out} \
   CONFIG.PMC_MIO_5_SCHMITT {1} \
   CONFIG.PMC_MIO_6_DIRECTION {out} \
   CONFIG.PMC_MIO_6_SCHMITT {1} \
   CONFIG.PMC_MIO_7_DIRECTION {out} \
   CONFIG.PMC_MIO_7_SCHMITT {1} \
   CONFIG.PMC_MIO_8_DIRECTION {inout} \
   CONFIG.PMC_MIO_9_DIRECTION {inout} \
   CONFIG.PMC_MIO_TREE_PERIPHERALS {QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#Loopback Clk#QSPI#QSPI#QSPI#QSPI#QSPI#QSPI#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD1/eMMC1#SD1/eMMC1#SD1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#SD1/eMMC1#GPIO 1###CAN 1#CAN 1#UART 0#UART 0#I2C 1#I2C 1#I2C 0#I2C 0#GPIO 1#GPIO 1##SD1/eMMC1#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 1#Enet 0#Enet 0} \
   CONFIG.PMC_MIO_TREE_SIGNALS {qspi0_clk#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_io[0]#qspi0_cs_b#qspi_lpbk#qspi1_cs_b#qspi1_io[0]#qspi1_io[1]#qspi1_io[2]#qspi1_io[3]#qspi1_clk#usb2phy_reset#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_tx_data[2]#ulpi_tx_data[3]#ulpi_clk#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#ulpi_dir#ulpi_stp#ulpi_nxt#clk#dir1/data[7]#detect#cmd#data[0]#data[1]#data[2]#data[3]#sel/data[4]#dir_cmd/data[5]#dir0/data[6]#gpio_1_pin[37]###phy_tx#phy_rx#rxd#txd#scl#sda#scl#sda#gpio_1_pin[48]#gpio_1_pin[49]##buspwr/rst#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem0_mdc#gem0_mdio} \
   CONFIG.PMC_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PMC_QSPI_PERIPHERAL_DATA_MODE {x4} \
   CONFIG.PMC_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_QSPI_PERIPHERAL_MODE {Dual Parallel} \
   CONFIG.PMC_SD1_DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PMC_SD1_GRP_CD_ENABLE {1} \
   CONFIG.PMC_SD1_GRP_CD_IO {PMC_MIO 28} \
   CONFIG.PMC_SD1_GRP_POW_ENABLE {1} \
   CONFIG.PMC_SD1_GRP_POW_IO {PMC_MIO 51} \
   CONFIG.PMC_SD1_PERIPHERAL_ENABLE {1} \
   CONFIG.PMC_SD1_PERIPHERAL_IO {PMC_MIO 26 .. 36} \
   CONFIG.PMC_SD1_SLOT_TYPE {SD 3.0} \
   CONFIG.PMC_SD1_SPEED_MODE {high speed} \
   CONFIG.PMC_USE_NOC_PMC_AXI0 {0} \
   CONFIG.PMC_USE_PMC_NOC_AXI0 {1} \
   CONFIG.PSPMC_MANUAL_CLOCK_ENABLE {1} \
   CONFIG.PS_CAN1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_CAN1_PERIPHERAL_IO {PMC_MIO 40 .. 41} \
   CONFIG.PS_CRF_ACPU_CTRL_ACT_FREQMHZ {999.989990} \
   CONFIG.PS_CRF_ACPU_CTRL_DIVISOR0 {1} \
   CONFIG.PS_CRF_ACPU_CTRL_SRCSEL {APLL} \
   CONFIG.PS_CRF_APLL_CTRL_CLKOUTDIV {4} \
   CONFIG.PS_CRF_APLL_CTRL_FBDIV {120} \
   CONFIG.PS_CRF_APLL_CTRL_SRCSEL {REF_CLK} \
   CONFIG.PS_CRF_APLL_TO_XPD_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRF_DBG_FPD_CTRL_ACT_FREQMHZ {299.997009} \
   CONFIG.PS_CRF_DBG_FPD_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRF_DBG_FPD_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRF_DBG_TRACE_CTRL_DIVISOR0 {3} \
   CONFIG.PS_CRF_DBG_TRACE_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRF_FPD_LSBUS_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_CRF_FPD_LSBUS_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRF_FPD_LSBUS_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRF_FPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {499.994995} \
   CONFIG.PS_CRF_FPD_TOP_SWITCH_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRF_FPD_TOP_SWITCH_CTRL_SRCSEL {APLL} \
   CONFIG.PS_CRL_CAN0_REF_CTRL_DIVISOR0 {12} \
   CONFIG.PS_CRL_CAN0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_ACT_FREQMHZ {149.998505} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_DIVISOR0 {4} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_FREQMHZ {150} \
   CONFIG.PS_CRL_CAN1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_CPM_TOPSW_REF_CTRL_ACT_FREQMHZ {474.995239} \
   CONFIG.PS_CRL_CPM_TOPSW_REF_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_CPM_TOPSW_REF_CTRL_SRCSEL {NPLL} \
   CONFIG.PS_CRL_CPU_R5_CTRL_ACT_FREQMHZ {374.996246} \
   CONFIG.PS_CRL_CPU_R5_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_CPU_R5_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_DBG_LPD_CTRL_ACT_FREQMHZ {299.997009} \
   CONFIG.PS_CRL_DBG_LPD_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_DBG_LPD_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_DBG_TSTMP_CTRL_ACT_FREQMHZ {299.997009} \
   CONFIG.PS_CRL_DBG_TSTMP_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_DBG_TSTMP_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_GEM0_REF_CTRL_ACT_FREQMHZ {124.998749} \
   CONFIG.PS_CRL_GEM0_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_GEM0_REF_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_GEM1_REF_CTRL_ACT_FREQMHZ {124.998749} \
   CONFIG.PS_CRL_GEM1_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_GEM1_REF_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_GEM_TSU_REF_CTRL_ACT_FREQMHZ {249.997498} \
   CONFIG.PS_CRL_GEM_TSU_REF_CTRL_DIVISOR0 {3} \
   CONFIG.PS_CRL_GEM_TSU_REF_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_I2C0_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_CRL_I2C0_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_I2C0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_I2C1_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_CRL_I2C1_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_I2C1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_IOU_SWITCH_CTRL_DIVISOR0 {3} \
   CONFIG.PS_CRL_IOU_SWITCH_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_LPD_LSBUS_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_CRL_LPD_LSBUS_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_LPD_LSBUS_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_LPD_TOP_SWITCH_CTRL_ACT_FREQMHZ {374.996246} \
   CONFIG.PS_CRL_LPD_TOP_SWITCH_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_LPD_TOP_SWITCH_CTRL_SRCSEL {RPLL} \
   CONFIG.PS_CRL_PSM_REF_CTRL_ACT_FREQMHZ {299.997009} \
   CONFIG.PS_CRL_PSM_REF_CTRL_DIVISOR0 {2} \
   CONFIG.PS_CRL_PSM_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_RPLL_CTRL_CLKOUTDIV {4} \
   CONFIG.PS_CRL_RPLL_CTRL_FBDIV {90} \
   CONFIG.PS_CRL_RPLL_CTRL_SRCSEL {REF_CLK} \
   CONFIG.PS_CRL_RPLL_TO_XPD_CTRL_DIVISOR0 {3} \
   CONFIG.PS_CRL_SPI0_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_SPI0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_SPI1_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_SPI1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_TIMESTAMP_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_TIMESTAMP_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_UART0_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_CRL_UART0_REF_CTRL_DIVISOR0 {6} \
   CONFIG.PS_CRL_UART0_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_UART1_REF_CTRL_DIVISOR0 {12} \
   CONFIG.PS_CRL_UART1_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_ACT_FREQMHZ {19.999800} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_DIVISOR0 {30} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_FREQMHZ {60} \
   CONFIG.PS_CRL_USB0_BUS_REF_CTRL_SRCSEL {PPLL} \
   CONFIG.PS_CRL_USB3_DUAL_REF_CTRL_ACT_FREQMHZ {9.999900} \
   CONFIG.PS_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PS_ENET0_GRP_MDIO_IO {PS_MIO 24 .. 25} \
   CONFIG.PS_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_ENET0_PERIPHERAL_IO {PS_MIO 0 .. 11} \
   CONFIG.PS_ENET1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_ENET1_PERIPHERAL_IO {PS_MIO 12 .. 23} \
   CONFIG.PS_GEM0_ROUTE_THROUGH_FPD {1} \
   CONFIG.PS_GEM1_ROUTE_THROUGH_FPD {1} \
   CONFIG.PS_GEN_IPI_0_ENABLE {1} \
   CONFIG.PS_GEN_IPI_0_MASTER {A72} \
   CONFIG.PS_GEN_IPI_1_ENABLE {1} \
   CONFIG.PS_GEN_IPI_1_MASTER {R5_0} \
   CONFIG.PS_GEN_IPI_2_ENABLE {1} \
   CONFIG.PS_GEN_IPI_2_MASTER {R5_1} \
   CONFIG.PS_GEN_IPI_3_ENABLE {1} \
   CONFIG.PS_GEN_IPI_3_MASTER {A72} \
   CONFIG.PS_GEN_IPI_4_ENABLE {1} \
   CONFIG.PS_GEN_IPI_4_MASTER {A72} \
   CONFIG.PS_GEN_IPI_5_ENABLE {1} \
   CONFIG.PS_GEN_IPI_5_MASTER {A72} \
   CONFIG.PS_GEN_IPI_6_ENABLE {1} \
   CONFIG.PS_GEN_IPI_6_MASTER {A72} \
   CONFIG.PS_GEN_IPI_PMCNOBUF_ENABLE {1} \
   CONFIG.PS_GEN_IPI_PMC_ENABLE {1} \
   CONFIG.PS_GEN_IPI_PSM_ENABLE {1} \
   CONFIG.PS_GPIO2_MIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_I2C0_PERIPHERAL_IO {PMC_MIO 46 .. 47} \
   CONFIG.PS_I2C1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_I2C1_PERIPHERAL_IO {PMC_MIO 44 .. 45} \
   CONFIG.PS_MIO_0_DIRECTION {out} \
   CONFIG.PS_MIO_0_SCHMITT {1} \
   CONFIG.PS_MIO_12_DIRECTION {out} \
   CONFIG.PS_MIO_12_SCHMITT {1} \
   CONFIG.PS_MIO_13_DIRECTION {out} \
   CONFIG.PS_MIO_13_SCHMITT {1} \
   CONFIG.PS_MIO_14_DIRECTION {out} \
   CONFIG.PS_MIO_14_SCHMITT {1} \
   CONFIG.PS_MIO_15_DIRECTION {out} \
   CONFIG.PS_MIO_15_SCHMITT {1} \
   CONFIG.PS_MIO_16_DIRECTION {out} \
   CONFIG.PS_MIO_16_SCHMITT {1} \
   CONFIG.PS_MIO_17_DIRECTION {out} \
   CONFIG.PS_MIO_17_SCHMITT {1} \
   CONFIG.PS_MIO_1_DIRECTION {out} \
   CONFIG.PS_MIO_1_SCHMITT {1} \
   CONFIG.PS_MIO_24_DIRECTION {out} \
   CONFIG.PS_MIO_24_SCHMITT {1} \
   CONFIG.PS_MIO_25_DIRECTION {inout} \
   CONFIG.PS_MIO_2_DIRECTION {out} \
   CONFIG.PS_MIO_2_SCHMITT {1} \
   CONFIG.PS_MIO_3_DIRECTION {out} \
   CONFIG.PS_MIO_3_SCHMITT {1} \
   CONFIG.PS_MIO_4_DIRECTION {out} \
   CONFIG.PS_MIO_4_SCHMITT {1} \
   CONFIG.PS_MIO_5_DIRECTION {out} \
   CONFIG.PS_MIO_5_SCHMITT {1} \
   CONFIG.PS_M_AXI_GP0_DATA_WIDTH {128} \
   CONFIG.PS_M_AXI_GP2_DATA_WIDTH {128} \
   CONFIG.PS_NUM_FABRIC_RESETS {1} \
   CONFIG.PS_S_AXI_GP0_DATA_WIDTH {128} \
   CONFIG.PS_S_AXI_GP2_DATA_WIDTH {128} \
   CONFIG.PS_TTC0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_TTC0_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_TTC0_REF_CTRL_FREQMHZ {99.999001} \
   CONFIG.PS_TTC1_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_TTC1_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_TTC1_REF_CTRL_FREQMHZ {99.999001} \
   CONFIG.PS_TTC2_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_TTC2_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_TTC2_REF_CTRL_FREQMHZ {99.999001} \
   CONFIG.PS_TTC3_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_TTC3_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_TTC3_REF_CTRL_FREQMHZ {99.999001} \
   CONFIG.PS_UART0_BAUD_RATE {115200} \
   CONFIG.PS_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_UART0_PERIPHERAL_IO {PMC_MIO 42 .. 43} \
   CONFIG.PS_USB3_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_USE_IRQ_0 {1} \
   CONFIG.PS_USE_IRQ_1 {0} \
   CONFIG.PS_USE_IRQ_2 {0} \
   CONFIG.PS_USE_IRQ_3 {0} \
   CONFIG.PS_USE_IRQ_4 {0} \
   CONFIG.PS_USE_IRQ_5 {0} \
   CONFIG.PS_USE_IRQ_6 {0} \
   CONFIG.PS_USE_IRQ_7 {0} \
   CONFIG.PS_USE_IRQ_8 {0} \
   CONFIG.PS_USE_M_AXI_GP0 {1} \
   CONFIG.PS_USE_M_AXI_GP2 {0} \
   CONFIG.PS_USE_NOC_PS_CCI_0 {0} \
   CONFIG.PS_USE_PMCPL_CLK0 {1} \
   CONFIG.PS_USE_PS_NOC_CCI {1} \
   CONFIG.PS_USE_PS_NOC_NCI_0 {1} \
   CONFIG.PS_USE_PS_NOC_NCI_1 {1} \
   CONFIG.PS_USE_PS_NOC_RPU_0 {1} \
   CONFIG.PS_USE_S_AXI_GP0 {0} \
   CONFIG.PS_USE_S_AXI_GP2 {0} \
   CONFIG.PS_WDT0_REF_CTRL_ACT_FREQMHZ {99.999001} \
   CONFIG.PS_WDT0_REF_CTRL_FREQMHZ {99.999001} \
   CONFIG.PS_WDT0_REF_CTRL_SEL {APB} \
   CONFIG.PS_WWDT0_CLOCK_IO {APB} \
   CONFIG.PS_WWDT0_PERIPHERAL_ENABLE {1} \
   CONFIG.PS_WWDT0_PERIPHERAL_IO {EMIO} \
 ] $CIPS_0

  # Create instance: cips_noc, and set properties
  set cips_noc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc cips_noc ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {10} \
   CONFIG.NUM_MC {0} \
   CONFIG.NUM_MCP {0} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_NMI {2} \
   CONFIG.LOGO_FILE {data/noc.png} \
   CONFIG.MC_CHAN_REGION0 {NONE} \
   CONFIG.NUM_NSI {0} \
   CONFIG.NUM_SI {8} \
 ] $cips_noc

 # Create instance: noc_ddr, and set properties
  set noc_ddr4 [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 noc_ddr4 ]
  set_property -dict [ list \
    CONFIG.CONTROLLERTYPE {DDR4_SDRAM} \
    CONFIG.CH0_DDR4_0_BOARD_INTERFACE {ddr4_dimm1} \
    CONFIG.sys_clk0_BOARD_INTERFACE {ddr4_dimm1_sma_clk} \
    CONFIG.MC_BA_WIDTH {2} \
    CONFIG.MC_BG_WIDTH {2} \
    CONFIG.MC_CHAN_REGION0 {DDR_LOW0} \
    CONFIG.MC_CHAN_REGION1 {DDR_LOW1} \
    CONFIG.MC_COMPONENT_WIDTH {x8} \
    CONFIG.MC_CONFIG_NUM {config17} \
    CONFIG.MC_DATAWIDTH {64} \
    CONFIG.MC_DDR4_2T {Disable} \
    CONFIG.MC_F1_LPDDR4_MR1 {0x0000} \
    CONFIG.MC_F1_LPDDR4_MR2 {0x0000} \
    CONFIG.MC_F1_TRCD {13750} \
    CONFIG.MC_F1_TRCDMIN {13750} \
    CONFIG.MC_INPUTCLK0_PERIOD {5000} \
    CONFIG.MC_INPUT_FREQUENCY0 {200.000} \
    CONFIG.MC_INTERLEAVE_SIZE {128} \
    CONFIG.MC_MEMORY_DEVICETYPE {UDIMMs} \
    CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
    CONFIG.MC_MEMORY_TIMEPERIOD0 {625} \
    CONFIG.MC_NO_CHANNELS {Single} \
    CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {ROW_COLUMN_BANK} \
    CONFIG.MC_RANK {1} \
    CONFIG.MC_ROWADDRESSWIDTH {16} \
    CONFIG.MC_TRC {45750} \
    CONFIG.MC_TRCD {13750} \
    CONFIG.MC_TRCDMIN {13750} \
    CONFIG.MC_TRCMIN {45750} \
    CONFIG.MC_TRP {13750} \
    CONFIG.MC_TRPMIN {13750} \
    CONFIG.NUM_SI {0} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NSI {1} \
    CONFIG.NUM_CLKS {0} \
    CONFIG.NUM_MC {1} \
    CONFIG.NUM_MCP {4} \
    CONFIG.LOGO_FILE {data/noc_mc.png}
    ] $noc_ddr4

   set noc_lpddr4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.0 noc_lpddr4 ]
    set_property -dict [ list \
   CONFIG.CH0_LPDDR4_0_BOARD_INTERFACE {ch0_lpddr4_c0} \
   CONFIG.CH0_LPDDR4_1_BOARD_INTERFACE {ch0_lpddr4_c1} \
   CONFIG.CH1_LPDDR4_0_BOARD_INTERFACE {ch1_lpddr4_c0} \
   CONFIG.CH1_LPDDR4_1_BOARD_INTERFACE {ch1_lpddr4_c1} \
   CONFIG.MC_CHAN_REGION0 {DDR_CH1} \
   CONFIG.MC_CHAN_REGION1 {NONE} \
   CONFIG.NUM_CLKS {0} \
   CONFIG.NUM_MCP {1} \
   CONFIG.NUM_MI {0} \
   CONFIG.NUM_NSI {1} \
   CONFIG.NUM_SI {0} \
   CONFIG.sys_clk0_BOARD_INTERFACE {lpddr4_sma_clk1} \
   CONFIG.sys_clk1_BOARD_INTERFACE {lpddr4_sma_clk2} \
 ] $noc_lpddr4
  
  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 { read_bw {128} write_bw {128} read_avg_burst {4} write_avg_burst {4}} } \
 ] [get_bd_intf_pins /noc_ddr4/S00_INI]

  set_property -dict [ list \
   CONFIG.CONNECTIONS {MC_0 { read_bw {1720} write_bw {1720} read_avg_burst {4} write_avg_burst {4}} } \
 ] [get_bd_intf_pins /noc_lpddr4/S00_INI]

   set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.REGION {768} \
   CONFIG.CATEGORY {aie} \
 ] [get_bd_intf_pins /cips_noc/M00_AXI]

   set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS { M01_INI { read_bw {128} write_bw {128}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_INI { read_bw {128} write_bw {128}} } \
   CONFIG.DEST_IDS {M01_AXI:0x0} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /cips_noc/S00_AXI]


   set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS { M01_INI { read_bw {128} write_bw {128}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_INI { read_bw {128} write_bw {128}} } \
   CONFIG.DEST_IDS {M00_AXI::0x0} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /cips_noc/S01_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS { M01_INI { read_bw {128} write_bw {128}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_INI { read_bw {128} write_bw {128}} } \
   CONFIG.DEST_IDS {M00_AXI::0x0} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /cips_noc/S02_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS { M01_INI { read_bw {128} write_bw {128}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_INI { read_bw {128} write_bw {128}} } \
   CONFIG.DEST_IDS {M00_AXI::0x0} \
   CONFIG.CATEGORY {ps_cci} \
 ] [get_bd_intf_pins /cips_noc/S03_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS { M01_INI { read_bw {128} write_bw {128}} M00_INI { read_bw {128} write_bw {128}} } \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /cips_noc/S04_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS { M01_INI { read_bw {128} write_bw {128}} M00_INI { read_bw {128} write_bw {128}} } \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_nci} \
 ] [get_bd_intf_pins /cips_noc/S05_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS { M01_INI { read_bw {128} write_bw {128}} M00_INI { read_bw {128} write_bw {128}} } \
   CONFIG.DEST_IDS {} \
   CONFIG.CATEGORY {ps_rpu} \
 ] [get_bd_intf_pins /cips_noc/S06_AXI]

  set_property -dict [ list \
   CONFIG.DATA_WIDTH {128} \
   CONFIG.CONNECTIONS { M01_INI { read_bw {128} write_bw {128}} M00_AXI { read_bw {5} write_bw {5} read_avg_burst {4} write_avg_burst {4}} M00_INI { read_bw {128} write_bw {128}} } \
   CONFIG.DEST_IDS {M00_AXI::0x0} \
   CONFIG.CATEGORY {ps_pmc} \
 ] [get_bd_intf_pins /cips_noc/S07_AXI]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
 ] [get_bd_pins /cips_noc/aclk0]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S00_AXI} \
 ] [get_bd_pins /cips_noc/aclk1]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S01_AXI} \
 ] [get_bd_pins /cips_noc/aclk2]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S02_AXI} \
 ] [get_bd_pins /cips_noc/aclk3]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S03_AXI} \
 ] [get_bd_pins /cips_noc/aclk4]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S04_AXI} \
 ] [get_bd_pins /cips_noc/aclk5]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S05_AXI} \
 ] [get_bd_pins /cips_noc/aclk6]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S06_AXI} \
 ] [get_bd_pins /cips_noc/aclk7]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {S07_AXI} \
 ] [get_bd_pins /cips_noc/aclk8]

  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {M00_AXI} \
 ] [get_bd_pins /cips_noc/aclk9]

  # Create instance: ai_engine_0, and set properties
  set ai_engine_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ai_engine ai_engine_0 ]
  set_property -dict [ list \
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

  # Create instance: axi_intc_0, and set properties
   set axi_intc_cascaded_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc axi_intc_cascaded_1 ]
  set_property -dict [ list \
   CONFIG.C_IRQ_CONNECTION {1} \
   CONFIG.C_ASYNC_INTR  {0xFFFFFFFF} \
 ] $axi_intc_cascaded_1
  
 set axi_intc_parent [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc axi_intc_parent ]
  set_property -dict [ list \
   CONFIG.C_IRQ_CONNECTION {1} \
   CONFIG.C_ASYNC_INTR  {0xFFFFFFFF} \
 ] $axi_intc_parent

 
 create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
 set_property -dict [list CONFIG.NUM_PORTS {32} CONFIG.IN0_WIDTH {1}] [get_bd_cells xlconcat_0]



  # Create instance: clk_wizard_0, and set properties
  set clk_wizard_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard clk_wizard_0 ]
  set_property -dict [ list \
   CONFIG.CLKOUT2_DIVIDE {20.000000} \
   CONFIG.CLKOUT3_DIVIDE {10.000000} \
   CONFIG.CLKOUT_DRIVES {BUFG,BUFG,BUFG,BUFG,BUFG,BUFG,BUFG} \
   CONFIG.CLKOUT_DYN_PS {None,None,None,None,None,None,None} \
   CONFIG.CLKOUT_MATCHED_ROUTING {false,false,false,false,false,false,false} \
   CONFIG.CLKOUT_PORT {clk_out1,clk_out2,clk_out3,clk_out4,clk_out5,clk_out6,clk_out7} \
   CONFIG.CLKOUT_REQUESTED_DUTY_CYCLE {50.000,50.000,50.000,50.000,50.000,50.000,50.000} \
   CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {100.000,150,300,75,200,400,600} \
   CONFIG.CLKOUT_REQUESTED_PHASE {0.000,0.000,0.000,0.000,0.000,0.000,0.000} \
   CONFIG.CLKOUT_USED {true,true,true,true,true,true,true} \
   CONFIG.JITTER_SEL {Min_O_Jitter} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {true} \
   CONFIG.USE_PHASE_ALIGNMENT {true} \
   CONFIG.USE_RESET {true} \
 ] $clk_wizard_0

  # Create instance: psr_100mh, and set properties
  set psr_100mhz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset psr_100mhz ]

  # Create instance: psr_150mh, and set properties
  set psr_150mhz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset psr_150mhz ]

  # Create instance: psr_300mh, and set properties
  set psr_300mhz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset psr_300mhz ]

  # Create instance: psr_75mh, and set properties
  set psr_75mhz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset psr_75mhz ]

  # Create instance: psr_200mh, and set properties
  set psr_200mhz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset psr_200mhz ]

  # Create instance: psr_400mh, and set properties
  set psr_400mhz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset psr_400mhz ]

  # Create instance: psr_600mh, and set properties
  set psr_600mhz [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset psr_600mhz ]

  # Create instance: smartconnect_1, and set properties
  set icn_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect icn_ctrl_1 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {2} \
   CONFIG.NUM_MI {6} \
   CONFIG.NUM_SI {1} \
 ] $icn_ctrl_1

   set icn_ctrl_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect icn_ctrl_2 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $icn_ctrl_2

  set to_delete_kernel_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip to_delete_kernel_ctrl_0 ]
  set_property -dict [ list \
  CONFIG.INTERFACE_MODE {SLAVE} \
  ] $to_delete_kernel_ctrl_0

  set to_delete_kernel_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip to_delete_kernel_ctrl_1 ]
  set_property -dict [ list \
  CONFIG.INTERFACE_MODE {SLAVE} \
  ] $to_delete_kernel_ctrl_1

  set to_delete_kernel_ctrl_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip to_delete_kernel_ctrl_2 ]
  set_property -dict [ list \
  CONFIG.INTERFACE_MODE {SLAVE} \
  ] $to_delete_kernel_ctrl_2
  
  set to_delete_kernel_ctrl_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip to_delete_kernel_ctrl_3 ]
  set_property -dict [ list \
  CONFIG.INTERFACE_MODE {SLAVE} \
  ] $to_delete_kernel_ctrl_3
  
  set icn_ctrl_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect icn_ctrl_3 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $icn_ctrl_3

 set icn_ctrl_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect icn_ctrl_4 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $icn_ctrl_4

 set icn_ctrl_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect icn_ctrl_5 ]
  set_property -dict [ list \
   CONFIG.NUM_CLKS {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {1} \
 ] $icn_ctrl_5


set_property platform.num_compute_units 63 [current_project]
  # Create interface connections
  connect_bd_intf_net -intf_net CIPS_0_IF_PMC_NOC_AXI_0 [get_bd_intf_pins CIPS_0/PMC_NOC_AXI_0]          [get_bd_intf_pins cips_noc/S07_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_CCI_0  [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_0]          [get_bd_intf_pins cips_noc/S00_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_CCI_1  [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_1]          [get_bd_intf_pins cips_noc/S01_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_CCI_2  [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_2]          [get_bd_intf_pins cips_noc/S02_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_CCI_3  [get_bd_intf_pins CIPS_0/FPD_CCI_NOC_3]          [get_bd_intf_pins cips_noc/S03_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_NCI_0  [get_bd_intf_pins CIPS_0/FPD_AXI_NOC_0]          [get_bd_intf_pins cips_noc/S04_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_NCI_1  [get_bd_intf_pins CIPS_0/FPD_AXI_NOC_1]          [get_bd_intf_pins cips_noc/S05_AXI]
  connect_bd_intf_net -intf_net CIPS_0_IF_PS_NOC_RPU_0  [get_bd_intf_pins CIPS_0/NOC_LPD_AXI_0]          [get_bd_intf_pins cips_noc/S06_AXI]
  connect_bd_intf_net -intf_net CIPS_0_M_AXI_GP0        [get_bd_intf_pins CIPS_0/M_AXI_FPD]              [get_bd_intf_pins icn_ctrl_1/S00_AXI]
  connect_bd_intf_net -intf_net noc_ddr4_CH0_DDR4_0     [get_bd_intf_ports ddr4_dimm1]                   [get_bd_intf_pins noc_ddr4/CH0_DDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_0  [get_bd_intf_ports ch0_lpddr4_c0]                [get_bd_intf_pins noc_lpddr4/CH0_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH0_LPDDR4_1  [get_bd_intf_ports ch0_lpddr4_c1]                [get_bd_intf_pins noc_lpddr4/CH0_LPDDR4_1]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_0  [get_bd_intf_ports ch1_lpddr4_c0]                [get_bd_intf_pins noc_lpddr4/CH1_LPDDR4_0]
  connect_bd_intf_net -intf_net axi_noc_0_CH1_LPDDR4_1  [get_bd_intf_ports ch1_lpddr4_c1]                [get_bd_intf_pins noc_lpddr4/CH1_LPDDR4_1]
  connect_bd_intf_net -intf_net cips_noc_M00_AXI        [get_bd_intf_pins cips_noc/M00_AXI]              [get_bd_intf_pins ai_engine_0/S00_AXI]
  connect_bd_intf_net -intf_net noc_ddr4_S00_INI        [get_bd_intf_pins cips_noc/M00_INI]              [get_bd_intf_pins noc_ddr4/S00_INI]
  connect_bd_intf_net -intf_net cips_noc_M01_INI        [get_bd_intf_pins cips_noc/M01_INI]              [get_bd_intf_pins noc_lpddr4/S00_INI]
  connect_bd_intf_net -intf_net icn_ctrl_1_M02_AXI      [get_bd_intf_pins icn_ctrl_2/S00_AXI]            [get_bd_intf_pins icn_ctrl_1/M02_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_1_M03_AXI      [get_bd_intf_pins icn_ctrl_3/S00_AXI]            [get_bd_intf_pins icn_ctrl_1/M03_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_1_M00_AXI      [get_bd_intf_pins axi_intc_cascaded_1/s_axi]     [get_bd_intf_pins icn_ctrl_1/M00_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_1_M01_AXI      [get_bd_intf_pins axi_intc_parent/s_axi]         [get_bd_intf_pins icn_ctrl_1/M01_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_1_M04_AXI      [get_bd_intf_pins icn_ctrl_4/S00_AXI]            [get_bd_intf_pins icn_ctrl_1/M04_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_1_M05_AXI      [get_bd_intf_pins icn_ctrl_5/S00_AXI]            [get_bd_intf_pins icn_ctrl_1/M05_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_2_M00_AXI      [get_bd_intf_pins to_delete_kernel_ctrl_0/S_AXI] [get_bd_intf_pins icn_ctrl_2/M00_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_3_M00_AXI      [get_bd_intf_pins to_delete_kernel_ctrl_1/S_AXI] [get_bd_intf_pins icn_ctrl_3/M00_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_4_M00_AXI      [get_bd_intf_pins to_delete_kernel_ctrl_2/S_AXI] [get_bd_intf_pins icn_ctrl_4/M00_AXI]
  connect_bd_intf_net -intf_net icn_ctrl_5_M00_AXI      [get_bd_intf_pins to_delete_kernel_ctrl_3/S_AXI] [get_bd_intf_pins icn_ctrl_5/M00_AXI]
  connect_bd_intf_net                                   [get_bd_intf_ports ddr4_dimm1_sma_clk]           [get_bd_intf_pins noc_ddr4/sys_clk0]
  connect_bd_intf_net -intf_net lpddr4_sma_clk1_1       [get_bd_intf_ports lpddr4_sma_clk1]              [get_bd_intf_pins noc_lpddr4/sys_clk0]
  connect_bd_intf_net -intf_net lpddr4_sma_clk2_1       [get_bd_intf_ports lpddr4_sma_clk2]              [get_bd_intf_pins noc_lpddr4/sys_clk1]
  connect_bd_net                                        [get_bd_pins axi_intc_cascaded_1/irq]            [get_bd_pins xlconcat_0/In31]
  connect_bd_net                                        [get_bd_pins axi_intc_parent/intr]               [get_bd_pins xlconcat_0/dout]

  # Create port connections
  connect_bd_net -net CIPS_0_pl_clk0 [get_bd_pins CIPS_0/pl0_ref_clk] [get_bd_pins clk_wizard_0/clk_in1]
  connect_bd_net -net CIPS_0_pl_resetn1 [get_bd_pins CIPS_0/pl0_resetn] [get_bd_pins clk_wizard_0/resetn] [get_bd_pins psr_100mhz/ext_reset_in] [get_bd_pins psr_150mhz/ext_reset_in] [get_bd_pins psr_300mhz/ext_reset_in] [get_bd_pins psr_75mhz/ext_reset_in] [get_bd_pins psr_200mhz/ext_reset_in] [get_bd_pins psr_400mhz/ext_reset_in] [get_bd_pins psr_600mhz/ext_reset_in]
  connect_bd_net -net CIPS_0_ps_pmc_noc_axi0_clk [get_bd_pins CIPS_0/pmc_axi_noc_axi0_clk] [get_bd_pins cips_noc/aclk8]
  connect_bd_net -net CIPS_0_ps_ps_noc_cci_axi0_clk [get_bd_pins CIPS_0/fpd_cci_noc_axi0_clk] [get_bd_pins cips_noc/aclk1]
  connect_bd_net -net CIPS_0_ps_ps_noc_cci_axi1_clk [get_bd_pins CIPS_0/fpd_cci_noc_axi1_clk] [get_bd_pins cips_noc/aclk2]
  connect_bd_net -net CIPS_0_ps_ps_noc_cci_axi2_clk [get_bd_pins CIPS_0/fpd_cci_noc_axi2_clk] [get_bd_pins cips_noc/aclk3]
  connect_bd_net -net CIPS_0_ps_ps_noc_cci_axi3_clk [get_bd_pins CIPS_0/fpd_cci_noc_axi3_clk] [get_bd_pins cips_noc/aclk4]
  connect_bd_net -net CIPS_0_ps_ps_noc_nci_axi0_clk [get_bd_pins CIPS_0/fpd_axi_noc_axi0_clk] [get_bd_pins cips_noc/aclk5]
  connect_bd_net -net CIPS_0_ps_ps_noc_nci_axi1_clk [get_bd_pins CIPS_0/fpd_axi_noc_axi1_clk] [get_bd_pins cips_noc/aclk6]
  connect_bd_net -net CIPS_0_ps_ps_noc_rpu_axi0_clk [get_bd_pins CIPS_0/lpd_axi_noc_clk] [get_bd_pins cips_noc/aclk7]
  connect_bd_net -net ai_engine_0_s00_axi_aclk [get_bd_pins cips_noc/aclk9] [get_bd_pins ai_engine_0/s00_axi_aclk]
  connect_bd_net -net axi_intc_3_irq [get_bd_pins CIPS_0/pl_ps_irq0] [get_bd_pins axi_intc_parent/irq]
  connect_bd_net -net clk_wizard_0_clk_out1 [get_bd_pins CIPS_0/m_axi_fpd_aclk] [get_bd_pins cips_noc/aclk0] [get_bd_pins axi_intc_cascaded_1/s_axi_aclk] [get_bd_pins axi_intc_parent/s_axi_aclk] [get_bd_pins clk_wizard_0/clk_out1] [get_bd_pins psr_100mhz/slowest_sync_clk] [get_bd_pins icn_ctrl_1/aclk] [get_bd_pins icn_ctrl_1/aclk1] [get_bd_pins icn_ctrl_2/aclk] [get_bd_pins icn_ctrl_3/aclk] [get_bd_pins to_delete_kernel_ctrl_0/aclk ] [get_bd_pins to_delete_kernel_ctrl_1/aclk ] [get_bd_pins icn_ctrl_4/aclk] [get_bd_pins icn_ctrl_5/aclk] [get_bd_pins to_delete_kernel_ctrl_2/aclk ] [get_bd_pins to_delete_kernel_ctrl_3/aclk ] 
  connect_bd_net -net clk_wizard_0_clk_out2 [get_bd_pins clk_wizard_0/clk_out2] [get_bd_pins psr_150mhz/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out3 [get_bd_pins clk_wizard_0/clk_out3] [get_bd_pins psr_300mhz/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out4 [get_bd_pins clk_wizard_0/clk_out4] [get_bd_pins psr_75mhz/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out5 [get_bd_pins clk_wizard_0/clk_out5] [get_bd_pins psr_200mhz/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out6 [get_bd_pins clk_wizard_0/clk_out6] [get_bd_pins psr_400mhz/slowest_sync_clk]
  connect_bd_net -net clk_wizard_0_clk_out7 [get_bd_pins clk_wizard_0/clk_out7] [get_bd_pins psr_600mhz/slowest_sync_clk]

  connect_bd_net -net clk_wizard_0_locked [get_bd_pins clk_wizard_0/locked] [get_bd_pins psr_100mhz/dcm_locked] [get_bd_pins psr_150mhz/dcm_locked] [get_bd_pins psr_300mhz/dcm_locked] [get_bd_pins psr_75mhz/dcm_locked] [get_bd_pins psr_200mhz/dcm_locked] [get_bd_pins psr_400mhz/dcm_locked] [get_bd_pins psr_600mhz/dcm_locked]
  connect_bd_net -net psr_100mhz_peripheral_aresetn [get_bd_pins axi_intc_cascaded_1/s_axi_aresetn] [get_bd_pins axi_intc_parent/s_axi_aresetn] [get_bd_pins psr_100mhz/peripheral_aresetn] [get_bd_pins icn_ctrl_1/aresetn] [get_bd_pins icn_ctrl_2/aresetn] [get_bd_pins icn_ctrl_3/aresetn] [get_bd_pins to_delete_kernel_ctrl_0/aresetn] [get_bd_pins to_delete_kernel_ctrl_1/aresetn] [get_bd_pins icn_ctrl_4/aresetn] [get_bd_pins icn_ctrl_5/aresetn] [get_bd_pins to_delete_kernel_ctrl_2/aresetn] [get_bd_pins to_delete_kernel_ctrl_3/aresetn]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x00000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW0] -force
  assign_bd_address -offset 0x800000000 -range 0x180000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x800000000 -range 0x180000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x800000000 -range 0x180000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x800000000 -range 0x180000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x800000000 -range 0x180000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x800000000 -range 0x180000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x800000000 -range 0x180000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x800000000 -range 0x180000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs noc_ddr4/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_RPU0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI0] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC]  [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x050000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_NCI1] [get_bd_addr_segs noc_lpddr4/S00_INI/C0_DDR_CH1x2] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_PMC]  [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI3] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI2] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI1] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0x020000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces CIPS_0/DATA_CCI0] [get_bd_addr_segs ai_engine_0/S00_AXI/AIE_ARRAY_0] -force
  assign_bd_address -offset 0xA4000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CIPS_0/Data1] [get_bd_addr_segs axi_intc_cascaded_1/S_AXI/Reg] -force
  assign_bd_address -offset 0xA5000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces CIPS_0/Data1] [get_bd_addr_segs axi_intc_parent/S_AXI/Reg] -force

  # Restore current instance
  current_bd_instance $oldCurInst
}
 create_root_design ""
 regenerate_bd_layout
 save_bd_design
