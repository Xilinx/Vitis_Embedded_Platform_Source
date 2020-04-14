# *************************************************************************
# Copyright 2019 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *************************************************************************

set name [get_property NAME [current_project]]
set output_file [format %s/../../dsa/%s.xsa [get_property DIRECTORY [current_project]] $name]
set bd zcu102_pl_ddr.bd

open_bd_design [get_files $bd]

set_property PFM_NAME [format "xilinx.com:board:%s:1.0" $name] [get_files $bd]

set_property PFM.CLOCK { \
                             clk_out1 {id "0" is_default "true" proc_sys_reset "psr_clk_300"} \
                             clk_out2 {id "1" is_default "false" proc_sys_reset "psr_clk_600"} \
                         }  [get_bd_cells /clk_wiz_0]

set_property PFM.AXI_PORT { \
                                M_AXI_HPM0_FPD {memport "M_AXI_GP"} \
                                M_AXI_HPM1_FPD {memport "M_AXI_GP"} \
                                S_AXI_HP0_FPD {memport "S_AXI_HP" sptag "HP0" memory "zynq_ultra_ps_e_0 HP0_DDR_LOW"} \
                                S_AXI_HP1_FPD {memport "S_AXI_HP" sptag "HP1" memory "zynq_ultra_ps_e_0 HP1_DDR_LOW"} \
                                S_AXI_HP2_FPD {memport "S_AXI_HP" sptag "HP2" memory "zynq_ultra_ps_e_0 HP2_DDR_LOW"} \
                                S_AXI_HP3_FPD {memport "S_AXI_HP" sptag "HP3" memory "zynq_ultra_ps_e_0 HP3_DDR_LOW"} \
                            } [get_bd_cells /zynq_ultra_ps_e_0]

set mig_master []
for {set i 1} {$i < 16} {incr i} {
    lappend mig_master S[format %02d $i]_AXI {memport "MIG" sptag "MIG0" memory "ddr4_0 C0_DDR4_ADDRESS_BLOCK"}
}
set_property PFM.AXI_PORT $mig_master [get_bd_cells /axi_smc]

set_property PFM.AXIS_PORT { \
                                 M_AXIS {type "M_AXIS" sptag "COUNTER"} \
                             } [get_bd_cells /counter_fifo]

set interrupts []
for {set i 0} {$i < 8} {incr i} {
    lappend interrupts In$i {}
}
set_property PFM.IRQ $interrupts [get_bd_cells /irq_concat_0]
set_property PFM.IRQ $interrupts [get_bd_cells /irq_concat_1]

generate_target all [get_files $bd]
reset_run synth_1
launch_runs -jobs 20 synth_1
wait_on_run synth_1

set_property dsa.post_sys_link_tcl_hook ./scripts/dynamic_postlink.tcl [current_project]
set_property dsa.vendor		"xilinx.com" [current_project]
set_property dsa.board_id	$name [current_project]
set_property dsa.name		$name [current_project]
set_property dsa.version	"1.0" [current_project]
set_property dsa.platform_state "pre_synth" [current_project]
set_property dsa.ip_cache_dir [get_property ip_output_repo [current_project]] [current_project]
write_hw_platform -force $output_file
