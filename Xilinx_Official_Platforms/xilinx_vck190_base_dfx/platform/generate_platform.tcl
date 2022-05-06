#
# (c) Copyright 2021 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# 
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
#

# parsing options
set options [dict create {*}$argv]

set static_xsa_path [dict get $options static_xsa_path]
set platform_name [dict get $options platform_name]
set rp_xsa_path [dict get $options rp_xsa_path]
set emu_xsa_path [dict get $options emu_xsa_path]
set platform_out [dict get $options platform_out]
set boot_dir_path [dict get $options boot_dir_path]
set img_dir_path [dict get $options img_dir_path]

if {$static_xsa_path eq ""} {
  error "***STATIC_XSA can't be empty, please rerun after setting it"
}
set rp_info_arg [list]
if { ($rp_xsa_path ne "") && ($emu_xsa_path ne "") && [file exists $rp_xsa_path] && [file exists $emu_xsa_path] } {
  lappend rp_info_arg id
  lappend rp_info_arg 0
  lappend rp_info_arg hw
  lappend rp_info_arg $rp_xsa_path
  lappend rp_info_arg hw_emu
  lappend rp_info_arg $emu_xsa_path
} elseif { $rp_xsa_path ne "" && [file exists $rp_xsa_path] } {
  lappend rp_info_arg id
  lappend rp_info_arg 0
  lappend rp_info_arg hw
  lappend rp_info_arg $rp_xsa_path
} else {
  error "***RP_XSA can't be empty, please rerun after setting it"
}

platform create -name $platform_name -desc " A base DFX platform targeting VCK190 which is the first Versal AI Core series evaluation kit, enabling designers to develop solutions using AI and DSP engines capable of delivering over 100X greater compute performance compared to current server class CPUs. This board includes 8GB of DDR4 UDIMM, 8GB LPDDR4 component, 400 AI engines, 1968 DSP engines, Dual-Core Arm® Cortex®-A72 and Dual-Core Cortex-R5. More information at https://www.xilinx.com/products/boards-and-kits/vck190.html" -hw $static_xsa_path -rp $rp_info_arg -out $platform_out -no-boot-bsp

domain create -name aiengine -os aie_runtime -proc {ai_engine} 
domain config -qemu-data $boot_dir_path
domain create -name xrt -proc psv_cortexa72 -os linux -sd-dir $img_dir_path 
domain config -hw-boot-bin $boot_dir_path/BOOT.BIN
domain config -boot $boot_dir_path
domain config -generate-bif

domain config -qemu-data $boot_dir_path

platform generate
