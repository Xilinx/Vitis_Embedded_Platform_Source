# Create PFM attributes
set_property PFM_NAME "xilinx.com:xd:${PLATFORM_NAME}:${VER}" [get_files [current_bd_design].bd]
set_property PFM.CLOCK {clk_out1 {id "2" is_default "true" proc_sys_reset "proc_sys_reset_100MHz" status "fixed"} clk_out2 {id "1" is_default "false" proc_sys_reset "proc_sys_reset_142MHz" status "fixed"} clk_out3 {id "0" is_default "false" proc_sys_reset "proc_sys_reset_142MHz" status "fixed"} clk_out4 {id "3" is_default "false" proc_sys_reset "proc_sys_reset_200MHz" status "fixed"} clk_out5 {id "4" is_default "false" proc_sys_reset "proc_sys_reset_50MHz" status "fixed"} clk_out6 {id "5" is_default "false" proc_sys_reset "proc_sys_reset_41MHz" status "fixed"}} [get_bd_cells /clk_wiz_0]

set hp0Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hp0Val S[format %02d $i]_AXI {memport "S_AXI_HP" sptag "HP0" memory "ps7 HP0_DDR_LOWOCM"}
}
set_property PFM.AXI_PORT $hp0Val [get_bd_cells /interconnect_axifull]
set_property PFM.AXI_PORT {M_AXI_GP1 {memport "M_AXI_GP" sptag "GP" memory ""} S_AXI_HP1 {memport "S_AXI_HP" sptag "HP1" memory "ps7 HP1_DDR_LOWOCM"} S_AXI_HP2 {memport "S_AXI_HP" sptag "HP2" memory "ps7 HP2_DDR_LOWOCM"} S_AXI_HP3 {memport "S_AXI_HP" sptag "HP3" memory "ps7 HP3_DDR_LOWOCM"}} [get_bd_cells /ps7]
set_property PFM.AXI_PORT {M01_AXI {memport "M_AXI_GP" sptag "" memory ""} M02_AXI {memport "M_AXI_GP" sptag "" memory ""} M03_AXI {memport "M_AXI_GP" sptag "" memory ""} M04_AXI {memport "M_AXI_GP" sptag "" memory ""} M05_AXI {memport "M_AXI_GP" sptag "" memory ""} M06_AXI {memport "M_AXI_GP" sptag "" memory ""} M07_AXI {memport "M_AXI_GP" sptag "" memory ""} M08_AXI {memport "M_AXI_GP" sptag "" memory ""} M09_AXI {memport "M_AXI_GP" sptag "" memory ""} M10_AXI {memport "M_AXI_GP" sptag "" memory ""} M11_AXI {memport "M_AXI_GP" sptag "" memory ""} M12_AXI {memport "M_AXI_GP" sptag "" memory ""} M13_AXI {memport "M_AXI_GP" sptag "" memory ""} M14_AXI {memport "M_AXI_GP" sptag "" memory ""} M15_AXI {memport "M_AXI_GP" sptag "" memory ""} M16_AXI {memport "M_AXI_GP" sptag "" memory ""} M17_AXI {memport "M_AXI_GP" sptag "" memory ""} M18_AXI {memport "M_AXI_GP" sptag "" memory ""} M19_AXI {memport "M_AXI_GP" sptag "" memory ""} M20_AXI {memport "M_AXI_GP" sptag "" memory ""} M21_AXI {memport "M_AXI_GP" sptag "" memory ""} M22_AXI {memport "M_AXI_GP" sptag "" memory ""} M23_AXI {memport "M_AXI_GP" sptag "" memory ""} M24_AXI {memport "M_AXI_GP" sptag "" memory ""} M25_AXI {memport "M_AXI_GP" sptag "" memory ""} M26_AXI {memport "M_AXI_GP" sptag "" memory ""} M27_AXI {memport "M_AXI_GP" sptag "" memory ""} M28_AXI {memport "M_AXI_GP" sptag "" memory ""} M29_AXI {memport "M_AXI_GP" sptag "" memory ""} M30_AXI {memport "M_AXI_GP" sptag "" memory ""} M31_AXI {memport "M_AXI_GP" sptag "" memory ""}} [get_bd_cells /ps7_axi_periph]

set_property PFM.IRQ {intr {id 0 range 32}} [get_bd_cells /axi_intc_0]
#Platform Properties
set_property platform.default_output_type "sd_card" [current_project]
set_property platform.design_intent.embedded "true" [current_project]
set_property platform.extensible "true" [current_project]
set_property platform.design_intent.server_managed "false" [current_project]
set_property platform.design_intent.external_host "false" [current_project]
set_property platform.design_intent.datacenter "false" [current_project]

validate_bd_design
save_bd_design

make_wrapper -files [get_files ./xilinx_zc706_base/xilinx_zc706_base.srcs/sources_1/bd/xilinx_zc706_base/xilinx_zc706_base.bd] -top
add_files -norecurse ./xilinx_zc706_base/xilinx_zc706_base.srcs/sources_1/bd/xilinx_zc706_base/hdl/xilinx_zc706_base_wrapper.v
generate_target all [get_files ./xilinx_zc706_base/xilinx_zc706_base.srcs/sources_1/bd/xilinx_zc706_base/xilinx_zc706_base.bd]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

