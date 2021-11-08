# Copyright 2021 Xilinx Inc.
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
if { ($rp_xsa_path ne "") && ($emu_xsa_path ne "")  && [file exists $rp_xsa_path] && [file exists $emu_xsa_path] } {
  lappend rp_info_arg id
  lappend rp_info_arg 0
  lappend rp_info_arg hw
  lappend rp_info_arg $rp_xsa_path
  lappend rp_info_arg hw_emu
  lappend rp_info_arg $emu_xsa_path
} elseif { $rp_xsa_path ne ""  && [file exists $rp_xsa_path] } {
  lappend rp_info_arg id
  lappend rp_info_arg 0
  lappend rp_info_arg hw
  lappend rp_info_arg $rp_xsa_path
} else {
  error "***RP_XSA can't be empty, please rerun after setting it"
}

platform -name $platform_name -desc "A basic Dynamic Function eXchange(DFX) platform targeting the ZCU102 evaluation board, which includes 4GB DDR4, GEM, USB, SDIO interface and UART of the Processing System. It reserves most of the PL resources for user to add acceleration kernels dynamically at run time"  -hw $static_xsa_path -rp $rp_info_arg -out $platform_out -no-boot-bsp

domain -name xrt -proc psu_cortexa53 -os linux -sd-dir $img_dir_path
domain config -boot $boot_dir_path
domain config -generate-bif
domain -runtime opencl
domain -qemu-data $boot_dir_path

platform -generate
