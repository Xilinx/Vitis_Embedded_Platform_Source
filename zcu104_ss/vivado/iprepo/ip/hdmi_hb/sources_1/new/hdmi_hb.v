`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2015 14:31:15
// Design Name: 
// Module Name: hdmi_hb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hdmi_hb(
    input       status_sb_aclk,
    input [1:0] status_sb_tdata,
    input       status_sb_tvalid,
    //output      status_sb_tready,
    input       link_clk,
    output      hdmi_hb
    );
    
wire       link_rdy;
(* dont_touch = "true" *) reg [23:0] hdmi_hb_cnt;
(* dont_touch = "true" *) reg        hdmi_hb_i;

assign link_rdy = status_sb_tdata[0];
assign hdmi_hb  = hdmi_hb_i;

always @ (negedge link_rdy, posedge link_clk)
begin
    if (~link_rdy)
    begin
        hdmi_hb_cnt <= 0;
        hdmi_hb_i   <= 0;
    end

    else
    begin
        if (hdmi_hb_cnt == 24'd10_000_000)
        begin
            hdmi_hb_cnt <= 0;
            hdmi_hb_i   <= ~hdmi_hb_i;
        end
        else
            hdmi_hb_cnt <= hdmi_hb_cnt + 1;
    end
end
endmodule
