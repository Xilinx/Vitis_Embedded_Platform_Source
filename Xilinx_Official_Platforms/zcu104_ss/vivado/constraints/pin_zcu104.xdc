###################
# Pin Constraints #
###################
#
# HDMI DRU Clock SI570
#
# PL Port           Pin  Schematic
#
# dru_clk_in_clk_n  U9   HDMI_DRU_CLOCK_C_N
# dru_clk_in_clk_p  U10  HDMI_DRU_CLOCK_C_P
#
set_property PACKAGE_PIN U10 [get_ports dru_clk_in_clk_p]
#
# HDMI RX
#
# PL Port                 Pin  Schematic
#
# hdmi_rx_clk_p_in        R10  HDMI_RX_CLK_C_P
# hdmi_rx_clk_n_in        R9   HDMI_RX_CLK_C_N
# hdmi_rx_dat_p_in[0]     N2   HDMI_RX0_C_P
# hdmi_rx_dat_n_in[0]     N1   HDMI_RX0_C_N
# hdmi_rx_dat_p_in[1]     L2   HDMI_RX1_C_P
# hdmi_rx_dat_n_in[1]     L1   HDMI_RX1_C_N
# hdmi_rx_dat_p_in[2]     J2   HDMI_RX2_C_P
# hdmi_rx_dat_n_in[2]     J1   HDMI_RX2_C_N
# hdmi_rx_ddc_out_scl_io  D2   HDMI_RX_SNK_SCL
# hdmi_rx_ddc_out_sda_io  E2   HDMI_RX_SNK_SDA
# hdmi_rx_hpd_out         F6   HDMI_RX_HPD
# hdmi_rx_det_in          E5   HDMI_RX_PWR_DET
#
set_property PACKAGE_PIN R10 [get_ports hdmi_rx_clk_p_in];
#
set_property PACKAGE_PIN D2 [get_ports hdmi_rx_ddc_out_scl_io]
set_property PACKAGE_PIN E2 [get_ports hdmi_rx_ddc_out_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_rx_ddc_out_*]
#
set_property PACKAGE_PIN F6 [get_ports hdmi_rx_hpd_out]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_rx_hpd_out]
#
set_property PACKAGE_PIN E5 [get_ports hdmi_rx_det_in]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_rx_det_in]
#
# HDMI TX
#
# PL Port                 Pin  Schematic
#
# hdmi_tx_clk_p_out       G21  HDMI_TX_LVDS_OUT_P
# hdmi_tx_clk_n_out       F21  HDMI_TX_LVDS_OUT_N
# hdmi_tx_dat_p_out[0]    M4   HDMI_TX0_P
# hdmi_tx_dat_n_out[0]    M3   HDMI_TX0_N
# hdmi_tx_dat_p_out[1]    L6   HDMI_TX1_P
# hdmi_tx_dat_n_out[1]    L5   HDMI_TX1_N
# hdmi_tx_dat_p_out[2]    K4   HDMI_TX2_P
# hdmi_tx_dat_n_out[2]    K3   HDMI_TX2_N
# hdmi_tx_ddc_out_scl_io  B1   HDMI_TX_SRC_SCL
# hdmi_tx_ddc_out_sda_io  C1   HDMI_TX_SRC_SDA
# hdmi_tx_hpd_in          E3   HDMI_TX_HPD
# hdmi_tx_en_out          A2   HDMI_TX_EN
#
set_property PACKAGE_PIN G21 [get_ports hdmi_tx_clk_p_out]
set_property IOSTANDARD LVDS [get_ports hdmi_tx_clk_p_out]
#
set_property PACKAGE_PIN B1 [get_ports hdmi_tx_ddc_out_scl_io]
set_property PACKAGE_PIN C1 [get_ports hdmi_tx_ddc_out_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_ddc_out_*]
#
set_property PACKAGE_PIN E3 [get_ports hdmi_tx_hpd_in]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_hpd_in]
#
set_property PACKAGE_PIN A2 [get_ports hdmi_tx_en_out]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_en_out]
#
# HDMI Clock Recovery 8T49N241
#
# PL Port           Pin  Schematic
#
# si5324_lol_in     N11  HDMI_8T49N241_LOL
# si5324_rst_out    M12  HDMI_8T49N241_RST
# si5324_clk_p_in   T8   HDMI_8T49N241_OUT_C_P
# si5324_clk_n_in   T7   HDMI_8T49N241_OUT_C_P
#
set_property PACKAGE_PIN T8 [get_ports si5324_clk_p_in]
#
set_property PACKAGE_PIN N11 [get_ports si5324_lol_in]
set_property IOSTANDARD LVCMOS33 [get_ports si5324_lol_in]
#
set_property PACKAGE_PIN M12 [get_ports si5324_rst_out]
set_property IOSTANDARD LVCMOS33 [get_ports si5324_rst_out]
#
# HDMI Control I2C
#
# PL Port              Pin  Schematic
#
# hdmi_ctl_iic_scl_io  D1   HDMI_CTL_SCL
# hdmi_ctl_iic_sda_io  E1   HDMI_CTL_SDA
#
set_property PACKAGE_PIN D1 [get_ports hdmi_ctl_iic_scl_io]
set_property PACKAGE_PIN E1 [get_ports hdmi_ctl_iic_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_ctl_iic_*]
#
# HDMI Status LED
#
set_property PACKAGE_PIN A5 [get_ports hdmi_tx_hb_led]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_hb_led]
#
set_property PACKAGE_PIN D5 [get_ports hdmi_tx_locked_led]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_tx_locked_led]
#
set_property PACKAGE_PIN B5 [get_ports hdmi_rx_hb_led]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_rx_hb_led]
#
# MIPI CSI-2 - I2C IMX274 Sensor
#
# PL Port            Pin  Schematic   FMC
#
# sensor_iic_scl_io  B9   LPC_LA26_P  D26  FMC_SCL
# sensor_iic_sda_io  B8   LPC_LA26_N  D27  FMC_SDA
#
set_property PACKAGE_PIN B9 [get_ports sensor_iic_scl_io]
set_property PACKAGE_PIN B8 [get_ports sensor_iic_sda_io]
set_property PULLUP true [get_ports sensor_iic_*]
set_property IOSTANDARD LVCMOS18 [get_ports sensor_iic_*]
#
# MIPI CSI-2 - GPIO - CAM_FLASH, CAM_XCE, CAM_RST
#
# PL Port               Pin  Schematic   FMC
#
# sensor_gpio_rst       H12  LPC_LA22_N  G25  FMC_RST
# sensor_gpio_spi_cs_n  A8   LPC_LA27_P  C26  FMC_SPI_CS_N
# sensor_gpio_flash     C17  LPC_LA16_N  G19  FMC_FLASH
#
set_property PACKAGE_PIN H12 [get_ports {sensor_gpio_rst}]
set_property IOSTANDARD LVCMOS18 [get_ports sensor_gpio_rst]
set_property PACKAGE_PIN A8  [get_ports {sensor_gpio_spi_cs_n}]
set_property IOSTANDARD LVCMOS18 [get_ports {sensor_gpio_spi_cs_n}]
set_property PACKAGE_PIN C17 [get_ports {sensor_gpio_flash}]
set_property IOSTANDARD LVCMOS12 [get_ports sensor_gpio_flash]
#
# The VRP pin in Bank 67 is not connected (NC). To use MIPI_DPHY_DCI on this bank,
# DCI Cascade must be used. Since Bank 66 has a 240 ohm resistor connected to the
# VRP pin, use Bank 66 as a DCI cascade master bank for Bank 66 (see AR# 67565).
#
set_property DCI_CASCADE {67} [get_iobanks 66]
