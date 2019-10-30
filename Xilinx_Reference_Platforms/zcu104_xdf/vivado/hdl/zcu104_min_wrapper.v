//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (lin64) Build 2640690 Sat Aug 31 19:29:57 MDT 2019
//Date        : Sun Sep  1 23:58:33 2019
//Host        : xsjra50 running 64-bit Ubuntu 16.04.6 LTS
//Command     : generate_target zcu104_xdf_wrapper.bd
//Design      : zcu104_xdf_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module zcu104_xdf_wrapper
   (dip_switch_4bits_tri_i,
    leds,
    push_button_4bits_tri_i);
  input [3:0]dip_switch_4bits_tri_i;
  output [3:0]leds;
  input [3:0]push_button_4bits_tri_i;

  wire [3:0]dip_switch_4bits_tri_i;
  wire [3:0]leds;
  wire [3:0]push_button_4bits_tri_i;

  zcu104_xdf zcu104_xdf_i
       (.dip_switch_4bits_tri_i(dip_switch_4bits_tri_i),
        .leds(leds),
        .push_button_4bits_tri_i(push_button_4bits_tri_i));
endmodule
