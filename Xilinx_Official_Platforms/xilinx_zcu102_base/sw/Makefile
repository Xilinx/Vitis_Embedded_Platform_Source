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

.PHONY: all linux clean

include ../platform.mk

all linux:
ifeq ("$(PETALINUX_BUILD)","TRUE")
	$(info )
	$(info You can skip PetaLinux building step by downloading common software image from https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-platforms.html and set PREBUILT_LINUX_PATH to point to software image.)
	$(info )
	$(MAKE) -C petalinux all
else
	$(MAKE) -C prebuilt_linux all
endif

clean:
		$(MAKE) -C prebuilt_linux clean;
		$(MAKE) -C petalinux clean;
