create_clock -period 10.000 -name status_sb_aclk [get_ports status_sb_aclk]
#set_property HD.CLK_SRC BUFGCTRL_X0Y0 [get_ports status_sb_aclk]

create_clock -period 3.333 -name link_clk [get_ports link_clk]
#set_property HD.CLK_SRC BUFGCTRL_X0Y1 [get_ports link_clk]

