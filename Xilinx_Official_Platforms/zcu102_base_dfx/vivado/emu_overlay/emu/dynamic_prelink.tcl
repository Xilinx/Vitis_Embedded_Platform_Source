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
# Skip BD supported IP check
set_param bd.skipSupportedIPCheck true

# Set HIP SLR automation level
set __sdx_hip_slr_automation_level 2
if {[info exists ::env(SDX_HIP_SLR_AUTOMATION_LEVEL)]} {
  set __sdx_hip_slr_automation_level $::env(SDX_HIP_SLR_AUTOMATION_LEVEL)
}
set_param ips.enableSLRParameter $__sdx_hip_slr_automation_level

