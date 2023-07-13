#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

# parsing options
set options [dict create {*}$argv]

set xsa_path [dict get $options xsa_path]
set platform_name [dict get $options platform_name]
set emu_xsa_path [dict get $options emu_xsa_path]
set platform_out [dict get $options platform_out]
set boot_dir_path [dict get $options boot_dir_path]
set img_dir_path [dict get $options img_dir_path]
set generate_sw [dict get $options generate_sw]

set plat_arg [list]
if {$xsa_path ne "" && [file exists $xsa_path] } {
  lappend plat_arg -hw 
  lappend plat_arg $xsa_path
}
if {$emu_xsa_path ne "" && [file exists $emu_xsa_path] } {
  lappend plat_arg -hw_emu
  lappend plat_arg $emu_xsa_path
}

if {$generate_sw} {
  # Generate sw components(eg: fsbl, pmufw)
  platform -name $platform_name {*}$plat_arg -out $platform_out
  domain -name xrt -proc psu_cortexa53 -os linux -sd-dir $img_dir_path
  platform -generate
  exit
}

platform -name $platform_name -desc "A basic static platform targeting the ZCU104 evaluation board, which includes 2GB DDR4, GEM, USB, SDIO interface and UART of the Processing System. It reserves most of the PL resources for user to add acceleration kernels" {*}$plat_arg -out $platform_out -no-boot-bsp

domain -name xrt -proc psu_cortexa53 -os linux -sd-dir $img_dir_path
domain config -boot $boot_dir_path
domain config -generate-bif
domain -runtime opencl
domain -qemu-data $boot_dir_path
#domain -sysroot ./src/aarch64-xilinx-linux

platform -generate
exit
