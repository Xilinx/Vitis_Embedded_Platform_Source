

#System Clock

set_property PACKAGE_PIN AH18 [get_ports si570_user_clk_p]
set_property IOSTANDARD LVDS [get_ports si570_user_clk_p]



## HDMI RX

#set_property PACKAGE_PIN R10 [get_ports HDMI_RX_CLK_P]

#set_property PACKAGE_PIN D2 [get_ports RX_DDC_scl_io]
#set_property PACKAGE_PIN E2 [get_ports RX_DDC_sda_io]
#set_property IOSTANDARD LVCMOS33 [get_ports RX_DDC_scl_io]
#set_property IOSTANDARD LVCMOS33 [get_ports RX_DDC_sda_io]
#set_property PACKAGE_PIN F6 [get_ports {RX_HPD[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {RX_HPD[0]}]
#set_property PACKAGE_PIN E5 [get_ports RX_DET]
#set_property IOSTANDARD LVCMOS33 [get_ports RX_DET]



#set_property IOSTANDARD LVDS [get_ports RX_REFCLK_P]
#set_property PACKAGE_PIN F22 [get_ports RX_REFCLK_P]

set_property IOSTANDARD LVDS [get_ports HDMI_TX_CLK_P]

set_property PACKAGE_PIN B1 [get_ports TX_DDC_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports TX_DDC_scl_io]

set_property PACKAGE_PIN C1 [get_ports TX_DDC_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports TX_DDC_sda_io]


set_property PACKAGE_PIN E3 [get_ports TX_HPD]
set_property IOSTANDARD LVCMOS33 [get_ports TX_HPD]

set_property PACKAGE_PIN A2 [get_ports {TX_EN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {TX_EN[0]}]

set_property PACKAGE_PIN T8 [get_ports TX_REFCLK_P]

set_property PACKAGE_PIN N11 [get_ports SI5319_LOL]
set_property IOSTANDARD LVCMOS33 [get_ports SI5319_LOL]

set_property PACKAGE_PIN M12 [get_ports {SI5319_RST[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SI5319_RST[0]}]
# I2C
set_property PACKAGE_PIN D1 [get_ports HDMI_CTRL_IIC_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_CTRL_IIC_scl_io]

set_property PACKAGE_PIN E1 [get_ports HDMI_CTRL_IIC_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports HDMI_CTRL_IIC_sda_io]



#set_property PACKAGE_PIN U10 [get_ports {DRU_CLK_clk_p[0]}]


# Misc
#GPIO_LED_0_LS
set_property PACKAGE_PIN D5 [get_ports {LED0[0]}]
#GPIO_LED_1_LS
set_property PACKAGE_PIN D6 [get_ports {LED1[0]}]
#GPIO_LED_2_LS
#GPIO_LED_3_LS
set_property PACKAGE_PIN B5 [get_ports {LED3[0]}]


set_property IOSTANDARD LVCMOS33 [get_ports LED*]

# compress bitstream
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]



# There is no defined phase relationship, hence they are treated as asynchronous



set_property PACKAGE_PIN G21 [get_ports HDMI_TX_CLK_P]




create_clock -period 3.333 [get_ports si570_user_clk_p]
set_input_jitter [get_clocks -of_objects [get_ports si570_user_clk_p]] 0.100
set_clock_groups -asynchronous -group [get_clocks -of [get_pins */clk_wiz_1/inst/mmcme4_adv_inst/CLKOUT0]] -group [get_clocks -of [get_pins */clk_wiz_1/inst/mmcme4_adv_inst/CLKOUT1]]
