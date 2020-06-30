# -------------------------------------------------------------------------
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
# -------------------------------------------------------------------------
# Define FPM NAME
set_property PFM_NAME "xilinx:xd:xilinx_zcu102_dynamic_5_1:5.1" [get_files pfm_dynamic.bd]

# Define AXI_PORT for AXI_LITE control
set parVal []
for {set i 1} {$i < 64} {incr i} {
  lappend parVal M[format %02d $i]_AXI {memport "M_AXI_GP"}
}
set_property PFM.AXI_PORT $parVal [get_bd_cells /interconnect_axilite_user_slr1]

set hp3Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hp3Val S[format %02d $i]_AXI {memport "S_AXI_HP" sptag "HP3" memory "interconnect_aximm_ddrmem2_M00_AXI Reg"}
}
set_property PFM.AXI_PORT $hp3Val [get_bd_cells /interconnect_axifull_1_user_slr1]


set hpc0Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hpc0Val S[format %02d $i]_AXI {memport "S_AXI_HP" sptag "HP0" memory "interconnect_aximm_ddrmem3_M00_AXI Reg"}
}
set_property PFM.AXI_PORT $hpc0Val [get_bd_cells /interconnect_axifull_2_user_slr1]

set hp1Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hp1Val S[format %02d $i]_AXI {memport "S_AXI_HP" sptag "HP1" memory "interconnect_aximm_ddrmem4_M00_AXI Reg"}
}
set_property PFM.AXI_PORT $hp1Val [get_bd_cells /axi_interconnect_0]

set hp2Val []
for {set i 1} {$i < 16} {incr i} {
  lappend hp2Val S[format %02d $i]_AXI {memport "S_AXI_HP" sptag "HP2" memory "interconnect_aximm_ddrmem5_M00_AXI Reg"}
}
set_property PFM.AXI_PORT $hp2Val [get_bd_cells /axi_interconnect_1]


# Define CLOCK
set_property PFM.CLOCK {clkwiz_kernel_clk_out1 {id "0" is_default "true" proc_sys_reset "reset_controllers/psreset_gate_pr_kernel"  status "fixed"} \
                       } [get_bd_ports /clkwiz_kernel_clk_out1]
set_property PFM.CLOCK {clkwiz_kernel2_clk_out1 {id "1" is_default "false" proc_sys_reset "reset_controllers/psreset_gate_pr_kernel2"  status "fixed"} \
                       } [get_bd_ports /clkwiz_kernel2_clk_out1]
set_property PFM.CLOCK {clkwiz_sysclks_clk_out2 {id "2" is_default "false" proc_sys_reset "/reset_controllers/psreset_gate_pr_control" status "fixed"} \
			} [get_bd_ports /clkwiz_sysclks_clk_out2]
set_property PFM.CLOCK {clkwiz_kernel3_clk_out {id "3" is_default "false" proc_sys_reset "/reset_controllers/psreset_gate_pr_kernel3" status "fixed"} \
			} [get_bd_ports /clkwiz_kernel3_clk_out]
set_property PFM.CLOCK {clkwiz_kernel4_clk_out {id "4" is_default "false" proc_sys_reset "/reset_controllers/psreset_gate_pr_kernel4" status "fixed"} \
			} [get_bd_ports /clkwiz_kernel4_clk_out]
set_property PFM.CLOCK {clkwiz_kernel5_clk_out {id "5" is_default "false" proc_sys_reset "/reset_controllers/psreset_gate_pr_kernel6" status "fixed"} \
			} [get_bd_ports /clkwiz_kernel5_clk_out]
set_property PFM.CLOCK {clkwiz_kernel6_clk_out {id "6" is_default "false" proc_sys_reset "/reset_controllers/psreset_gate_pr_kernel5" status "fixed"} \
			} [get_bd_ports /clkwiz_kernel6_clk_out]

set_property PFM.IRQ {In0 {id 0} In1 {id 1} In2 {id 2} In3 {id 3} In4 {id 4} In5 {id 5} In6 {id 6} In7 {id 7} In8 {id 8} In9 {id 9} In10 {id 10} In11 {id 11} In12 {id 12} In13 {id 13} In14 {id 14} In15 {id 15} In16 {id 16} In17 {id 17} In18 {id 18} In19 {id 19} In20 {id 20} In21 {id 21} In22 {id 22} In23 {id 23} In24 {id 24} In25 {id 25} In26 {id 26} In27 {id 27} In28 {id 28} In29 {id 29} In30 {id 30} In31 {id 31}} [get_bd_cells /interrupt_concat/xlconcat_interrupt_0]

