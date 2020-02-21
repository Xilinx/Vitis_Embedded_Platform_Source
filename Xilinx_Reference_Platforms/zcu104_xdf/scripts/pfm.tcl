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

set name zcu104_xdf

platform create -name $name -desc "ZCU104 minimum platform" -hw [format [pwd]/platform_repo/tmp/xsa/%s.xsa $name] -prebuilt -out [pwd]/output

domain -name xrt -display-name "A53 XRT Linux" -proc psu_cortexa53 -os linux -image ./platform_repo/tmp/sw_components/image
domain config -boot ./platform_repo/tmp/sw_components/boot
domain config -bif ./platform_repo/tmp/sw_components/boot/petalinux.bif
domain -runtime opencl

platform -generate
