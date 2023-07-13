#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

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
