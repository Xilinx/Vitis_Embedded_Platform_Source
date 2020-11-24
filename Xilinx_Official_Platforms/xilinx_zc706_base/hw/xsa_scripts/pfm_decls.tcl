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

set_property PFM.IRQ {In0 {id 0} In1 {id 1} In2 {id 2} In3 {id 3} In4 {id 4} In5 {id 5} In6 {id 6} In7 {id 7} In8 {id 8} In9 {id 9} In10 {id 10} In11 {id 11} In12 {id 12} In13 {id 13} In14 {id 14} In15 {id 15} In16 {id 16} In17 {id 17} In18 {id 18} In19 {id 19} In20 {id 20} In21 {id 21} In22 {id 22} In23 {id 23} In24 {id 24} In25 {id 25} In26 {id 26} In27 {id 27} In28 {id 28} In29 {id 29} In30 {id 30} In31 {id 31}} [get_bd_cells /interrupt_concat/xlconcat_interrupt_0]

  validate_bd_design
  save_bd_design
 make_wrapper -files [get_files ./xilinx_zc706_base/xilinx_zc706_base.srcs/sources_1/bd/xilinx_zc706_base/xilinx_zc706_base.bd] -top
 add_files -norecurse ./xilinx_zc706_base/xilinx_zc706_base.srcs/sources_1/bd/xilinx_zc706_base/hdl/xilinx_zc706_base_wrapper.v
 generate_target all [get_files ./xilinx_zc706_base/xilinx_zc706_base.srcs/sources_1/bd/xilinx_zc706_base/xilinx_zc706_base.bd]
 update_compile_order -fileset sources_1
 update_compile_order -fileset sim_1

 set_property platform.default_output_type "sd_card" [current_project]
 set_property platform.design_intent.embedded "true" [current_project]
 set_property platform.design_intent.server_managed "false" [current_project]
 set_property platform.design_intent.external_host "false" [current_project]
 set_property platform.design_intent.datacenter "false" [current_project]

#set_property platform.post_sys_link_tcl_hook        ./dynamic_postlink.tcl       [current_project]
set pre_synth ""

if { $argc > 1} {
   set pre_synth [lindex $argv 2]
}
if {$pre_synth} {
set_property platform.platform_state "pre_synth" [current_project]

write_hw_platform -force $PLATFORM_NAME.xsa
validate_hw_platform $PLATFORM_NAME.xsa -verbose 
} else {
set_property generate_synth_checkpoint true [get_files -norecurse *.bd]
launch_runs impl_1 -to_step write_bitstream -jobs 16
wait_on_run impl_1
write_hw_platform -force -include_bit $PLATFORM_NAME.xsa
#write_hw_platform -force ./xilinx_zc706_base.xsa
}
#generate README.hw
set board zc706

set fd [open README.hw w] 

set board [lindex $argv 0]

puts $fd "##########################################################################"
puts $fd "This is a brief document containing design specific details for : ${board}"
puts $fd "This is auto-generated by Petalinux ref-design builder created @ [clock format [clock seconds] -format {%a %b %d %H:%M:%S %Z %Y}]"
puts $fd "##########################################################################"

set board_part [get_board_parts [current_board_part -quiet]]
if { $board_part != ""} {
    puts $fd "BOARD: $board_part" 
  }

set design_name [get_property NAME [get_bd_designs]]
puts $fd "BLOCK DESIGN: $design_name" 

set columns {%40s%30s%15s%50s}
puts $fd [string repeat - 150]
puts $fd [format $columns "MODULE INSTANCE NAME" "IP TYPE" "IP VERSION" "IP"]
puts $fd [string repeat - 150]
foreach ip [get_ips] {
  set catlg_ip [get_ipdefs -all [get_property IPDEF $ip]] 
     puts $fd [format $columns [get_property NAME $ip] [get_property NAME $catlg_ip] [get_property VERSION $catlg_ip] [get_property VLNV $catlg_ip]]
}
close $fd

