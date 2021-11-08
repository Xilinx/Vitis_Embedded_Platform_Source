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

# Assign the AXI-Lite control interface apertures for the dynamic region
set __ctrl_addr_space_user [get_bd_addr_space -of_object [get_bd_intf_port /regslice_control_userpf_M_AXI]]
set_property range  {8M}        $__ctrl_addr_space_user
set_property offset {0x80800000} $__ctrl_addr_space_user
#assign_bd_address -boundary -combine_segments
validate_bd_design
assign_bd_address [get_bd_addr_segs {interconnect_aximm_ddrmem2_M00_AXI/Reg }] -range  2G -offset 0x00000000
assign_bd_address [get_bd_addr_segs {interconnect_aximm_ddrmem3_M00_AXI/Reg }] -range  2G -offset 0x00000000

#create_bd_addr_seg -range 0x00001000 -offset 0x81000000 [get_bd_addr_spaces regslice_control_userpf_M_AXI] [get_bd_addr_segs axi_gpio_null/S_AXI/Reg] SEG_axi_gpio_null_Reg

validate_bd_design

# Lock the dynamic region boundary interfaces after validation
#set l_ext_ports [list ddrmem_0_C0_DDR4 c0_sys regslice_control_M_AXI regslice_control_userpf_M_AXI regslice_data_M_AXI]
#set l_ext_ports [list ddrmem_0_C0_DDR4 interconnect_aximm_ddrmem1_M00_AXI c0_sys regslice_control_M_AXI regslice_control_userpf_M_AXI regslice_data_M_AXI]
set l_ext_ports [list interconnect_aximm_ddrmem2_M00_AXI interconnect_aximm_ddrmem3_M00_AXI c0_sys  regslice_control_userpf_M_AXI regslice_data_hpm0fpd_M_AXI1 interconnect_aximm_ddrmem5_M00_AXI interconnect_aximm_ddrmem4_M00_AXI]

foreach ext_port_name $l_ext_ports {
  set ext_port [get_bd_intf_ports -quiet $ext_port_name]
#  set conn_obj [find_bd_objs -quiet -relation connected_to $ext_port]
#  if {$conn_obj != "" } {
#    bd::update_intf_port -quiet -ref $conn_obj $ext_port
#  }
  set_property -quiet HDL_ATTRIBUTE.LOCKED true $ext_port
}

set l_ext_ports_1 [list  c0_sys  regslice_control_userpf_M_AXI]

foreach ext_port_name $l_ext_ports_1 {
  set ext_port [get_bd_intf_ports -quiet $ext_port_name]
  set conn_obj [find_bd_objs -quiet -relation connected_to $ext_port]
  if {$conn_obj != "" } {
    bd::update_intf_port -quiet -ref $conn_obj $ext_port
  }
#  set_property -quiet HDL_ATTRIBUTE.LOCKED true $ext_port
}

validate_bd_design
save_bd_design

# Set up the dynamic region for the PR flow
set_property PR_FLOW 1 [current_project]
#set pd [create_partition_def -name pfm_pd -module pfm_dynamic]
#create_reconfig_module -name bd_pfm_dynamic -partition_def $pd -define_from pfm_dynamic
#save_bd_design




