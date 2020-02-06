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

open_run impl_1


#set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
#set_property SEVERITY {Warning} [get_drc_checks UCIO-1]

set_property platform.EMU_OVERRIDE_DIR emu_overlay/emu_generated/emu/ [current_project]

#write_hw_platform -force -include_bit -ext_metadata "${sourcesDir}/misc/ext_metadata.json" xilinx_zcu102_dynamic_0_1.xsa
#validate_hw_platform xilinx_zcu102_dynamic_0_1.xsa -verbose
write_hw_platform -force -include_bit -ext_metadata "${sourcesDir}/misc/ext_metadata.json" zcu102_base_dfx.xsa
validate_hw_platform zcu102_base_dfx.xsa -verbose

write_hwdef -force  -file pfm_top_wrapper.hdf
