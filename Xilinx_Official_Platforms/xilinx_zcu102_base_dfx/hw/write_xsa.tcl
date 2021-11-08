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

set PLATFORM_NAME [lindex $argv 0]
open_run impl_1

write_hw_platform -force -hw -include_bit -ext_metadata "${sourcesDir}/misc/ext_metadata.json" -file hw.xsa
write_hwdef -force  -file pfm_top_wrapper.hdf
