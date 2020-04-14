//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2_sdx (lin64) Build 1972098 Wed Aug 23 11:34:38 MDT 2017
//Date        : Wed Nov 15 12:01:51 2017
//Host        : xsjra50 running 64-bit unknown
//Command     : generate_target zcu102_pl_ddr_wrapper.bd
//Design      : zcu102_pl_ddr_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module zcu102_pl_ddr_wrapper
   (ddr4_sdram_act_n,
    ddr4_sdram_adr,
    ddr4_sdram_ba,
    ddr4_sdram_bg,
    ddr4_sdram_ck_c,
    ddr4_sdram_ck_t,
    ddr4_sdram_cke,
    ddr4_sdram_cs_n,
    ddr4_sdram_dm_n,
    ddr4_sdram_dq,
    ddr4_sdram_dqs_c,
    ddr4_sdram_dqs_t,
    ddr4_sdram_odt,
    ddr4_sdram_reset_n,
    ddr_calibration_complete,
    mig_ref_clk_clk_n,
    mig_ref_clk_clk_p);
  output ddr4_sdram_act_n;
  output [16:0]ddr4_sdram_adr;
  output [1:0]ddr4_sdram_ba;
  output ddr4_sdram_bg;
  output ddr4_sdram_ck_c;
  output ddr4_sdram_ck_t;
  output ddr4_sdram_cke;
  output ddr4_sdram_cs_n;
  inout [1:0]ddr4_sdram_dm_n;
  inout [15:0]ddr4_sdram_dq;
  inout [1:0]ddr4_sdram_dqs_c;
  inout [1:0]ddr4_sdram_dqs_t;
  output ddr4_sdram_odt;
  output ddr4_sdram_reset_n;
  output ddr_calibration_complete;
  input mig_ref_clk_clk_n;
  input mig_ref_clk_clk_p;

  wire ddr4_sdram_act_n;
  wire [16:0]ddr4_sdram_adr;
  wire [1:0]ddr4_sdram_ba;
  wire ddr4_sdram_bg;
  wire ddr4_sdram_ck_c;
  wire ddr4_sdram_ck_t;
  wire ddr4_sdram_cke;
  wire ddr4_sdram_cs_n;
  wire [1:0]ddr4_sdram_dm_n;
  wire [15:0]ddr4_sdram_dq;
  wire [1:0]ddr4_sdram_dqs_c;
  wire [1:0]ddr4_sdram_dqs_t;
  wire ddr4_sdram_odt;
  wire ddr4_sdram_reset_n;
  wire ddr_calibration_complete;
  wire mig_ref_clk_clk_n;
  wire mig_ref_clk_clk_p;

  zcu102_pl_ddr zcu102_pl_ddr_i
       (.ddr4_sdram_act_n(ddr4_sdram_act_n),
        .ddr4_sdram_adr(ddr4_sdram_adr),
        .ddr4_sdram_ba(ddr4_sdram_ba),
        .ddr4_sdram_bg(ddr4_sdram_bg),
        .ddr4_sdram_ck_c(ddr4_sdram_ck_c),
        .ddr4_sdram_ck_t(ddr4_sdram_ck_t),
        .ddr4_sdram_cke(ddr4_sdram_cke),
        .ddr4_sdram_cs_n(ddr4_sdram_cs_n),
        .ddr4_sdram_dm_n(ddr4_sdram_dm_n),
        .ddr4_sdram_dq(ddr4_sdram_dq),
        .ddr4_sdram_dqs_c(ddr4_sdram_dqs_c),
        .ddr4_sdram_dqs_t(ddr4_sdram_dqs_t),
        .ddr4_sdram_odt(ddr4_sdram_odt),
        .ddr4_sdram_reset_n(ddr4_sdram_reset_n),
        .ddr_calibration_complete(ddr_calibration_complete),
        .mig_ref_clk_clk_n(mig_ref_clk_clk_n),
        .mig_ref_clk_clk_p(mig_ref_clk_clk_p));
endmodule
