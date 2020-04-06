#####
## Constraints for ZCU106
## Version 1.0
#####


#####
## Pins
#####
set_property PACKAGE_PIN AH18 [get_ports {si570_user_clk_p}]
set_property IOSTANDARD LVDS [get_ports {si570_user_clk_p}]

#SFP SI5328
#set_property PACKAGE_PIN W10 [get_ports {DRU_CLK_clk_p[0]}]
#SI570 - OUT OF SPEC CLOCK SOURCE LOCATION - DO NOT USE FOR PRODUCTION DESIGNS
#Override clock placement error
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets zcu106_vcu_trd_i/gt_refclk_buf/ibufds_gt/U0/IBUF_OUT[0]] 

################
## Clock Groups #
#################
#
## A BUFGMUX selects between DP and HDMI video clock to couple the TPG with the desired display interface
## The two clocks are exclusive since they don't exist at the same time
#set_clock_groups -logically_exclusive -group [get_clocks clk_pl_1] \
#                                      -group [get_clocks -of [get_pins */vid_phy_controller/inst/gt_usrclk_source_inst/tx_mmcm.txoutclk_mmcm0_i/mmcm_adv_inst/CLKOUT2]]


# MIPI CSI-2 - GPIO - CAM_FLASH, CAM_XCE, CAM_RST
#
# PL Port               Pin   Schematic    FMC
#
# sensor_gpio_rst       H12   HPC0_LA22_N  G25  FMC_RST
# sensor_gpio_spi_cs_n  A8   HPC0_LA27_P  C26  FMC_SPI_CS_N
# sensor_gpio_flash     C17  HPC0_LA16_N  G19  FMC_FLASH
#
set_property PACKAGE_PIN H12 [get_ports {sensor_gpio_rst}]
set_property IOSTANDARD LVCMOS18 [get_ports sensor_gpio_rst]
set_property PACKAGE_PIN A8 [get_ports {sensor_gpio_spi_cs_n}]
set_property IOSTANDARD LVCMOS18 [get_ports sensor_gpio_spi_cs_n]
set_property PACKAGE_PIN C17 [get_ports {sensor_gpio_flash}]
set_property IOSTANDARD LVCMOS12 [get_ports sensor_gpio_flash]

# MIPI CSI-2 - I2C IMX274 Sensor
#
# PL Port            Pin  Schematic    FMC
#
# sensor_iic_scl_io  L15  HPC0_LA26_P  D26  FMC_SCL
# sensor_iic_sda_io  K15  HPC0_LA26_N  D27  FMC_SDA
#
set_property PACKAGE_PIN B9 [get_ports sensor_iic_scl_io]
set_property PACKAGE_PIN B8 [get_ports sensor_iic_sda_io]
set_property PULLUP true [get_ports sensor_iic_*]
set_property IOSTANDARD LVCMOS18 [get_ports sensor_iic_*]

#WA for timing - hold violation during dephi build with 2018.2_released
#set_false_path -from [get_nets zcu104_hdmi_mipi_i/mipi_csi2_rx/v_frmbuf_wr_1/inst/MultiPixStream2Bytes_U0/pix_val_0_V_5_fu_504_reg[4]/C] -to [get_nets zcu104_hdmi_mipi_i/mipi_csi2_rx/v_frmbuf_wr_1/inst/MultiPixStream2Bytes_U0/ap_phi_reg_pp3_iter0_pix_val_V_0_21_i_i_reg_1998_reg[4]/D]

#set_false_path -from [get_nets zcu104_hdmi_mipi_i/axi_interconnect/m12_couplers/auto_cc/inst/gen_clock_conv.gen_async_conv.asyncfifo_axi/inst_fifo_gen/gaxi_full_lite.gread_ch.grdch2.axi_rdch/grf.rf/gntv_or_sync_fifo.mem/gdm.dm_gen.dm/gpr1.dout_i_reg[121]/C] -to [get_nets zcu104_hdmi_mipi_i/axi_interconnect/m12_couplers/auto_cc/inst/gen_clock_conv.gen_async_conv.asyncfifo_axi/inst_fifo_gen/gaxi_full_lite.gread_ch.grdch2.axi_rdch/grf.rf/gntv_or_sync_fifo.mem/goreg_dm.dout_i_reg[121]/D]

#set_false_path -from [get_nets zcu104_hdmi_mipi_i/axi_interconnect/m01_couplers/auto_ds/inst/gen_downsizer.gen_simple_downsizer.axi_downsizer_inst/USE_READ.read_addr_inst/wrap_unaligned_len_q_reg[4]/C] -to [get_nets zcu104_hdmi_mipi_i/axi_interconnect/m01_couplers/auto_ds/inst/gen_downsizer.gen_simple_downsizer.axi_downsizer_inst/USE_READ.read_addr_inst/wrap_rest_len_reg[4]/D]

#set_false_path -from [get_nets zcu104_hdmi_mipi_i/mipi_csi2_rx/mipi_csi2_rx_subsystem_0/inst/rx/inst/gen_pkt_fifo/pkt_fifo/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/rd_pntr_cdc_inst/dest_graysync_ff_reg[1][3]/C] -to [get_nets zcu104_hdmi_mipi_i/mipi_csi2_rx/mipi_csi2_rx_subsystem_0/inst/rx/inst/gen_pkt_fifo/pkt_fifo/U0/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/rd_pntr_cdc_inst/dest_out_bin_ff_reg[2]/D]

#set_false_path -from [get_nets zcu104_hdmi_mipi_i/mipi_csi2_rx/v_frmbuf_wr_0/inst/AXIvideo2MultiPixStr_U0/AXI_video_strm_V_data_V_0_payload_B_reg[5]/C] -to [get_nets zcu104_hdmi_mipi_i/mipi_csi2_rx/v_frmbuf_wr_0/inst/AXIvideo2MultiPixStr_U0/tmp_data_V_reg_699_reg[5]/D]

#set_false_path -from [get_nets zcu104_hdmi_mipi_i/mipi_csi2_rx/mipi_csi2_rx_subsystem_0/inst/phy/inst/bd_dfbf_phy_0_rx_support_i/slave_rx.dphy_rx_fab_top/gen_rx_data_lane[1].rx_data_lane_inst/rxactivehs_sync_i/s_level_out_d2_reg/C] -to [zcu104_hdmi_mipi_i/mipi_csi2_rx/mipi_csi2_rx_subsystem_0/inst/phy/inst/bd_dfbf_phy_0_rx_support_i/slave_rx.dphy_rx_fab_top/gen_rx_data_lane[1].rx_data_lane_inst/gen_hs_high_rates_spec_v1_1.rxactivehs_coreclk_sync_r_reg/D]

