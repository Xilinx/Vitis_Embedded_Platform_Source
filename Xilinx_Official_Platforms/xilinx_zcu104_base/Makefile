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

include platform.mk

############################## Help Section ##############################
.PHONY: help

help::
	@echo 'Makefile Usage:'
	@echo ''
	@echo '  All the make commands install platform to "platform_repo/$(PLATFORM_NAME)/export/$(PLATFORM_NAME)"'
	@echo ''
	@echo '  make all'
	@echo '      Command used to generate platform with pre-built software components.'
	@echo ''
	@echo '  make all PREBUILT_LINUX_PATH=<path/to/common_sw/dir'
	@echo '			 Command used to generate platform with pre-built software components. By default, makefile looks for pre-built images in current directory or /opt/xilinx/platform/. Path to pre-built common images present in another dir can be passed to makefile manually using this command'
	@echo ''
	@echo '  make all PETALINUX_BUILD=TRUE'
	@echo '      Command used to generate platform with petalinux. Source petalinux before running this command.'
	@echo '      This command builds all software components.'
	@echo ''
	@echo '  *************************************************************************************************************'
	@echo '  *                                                                                                           *'
	@echo '  *  Please download Prebuilt Image using the following URL :                                                 *'
	@echo '  *                                                                                                           *'
	@echo '  *  https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-platforms.html *'
	@echo '  *                                                                                                           *'
	@echo '  *************************************************************************************************************'
	@echo ''
	@echo '  make all PRE_SYNTH=FALSE'
	@echo '      Command used to generate platform with post-impl xsa and pre-built software components.'
	@echo '      By default, PRE_SYNTH=TRUE.'
	@echo ''
	@echo '  make all PRE_SYNTH=FALSE PETALINUX_BUILD=TRUE'
	@echo '      Command used to generate platform with post-impl xsa using petalinux. Source petalinux before running this command.'
	@echo '      By default, PRE_SYNTH=TRUE.'
	@echo ''
	@echo '  make linux XSA=/home/user/$(PLATFORM_NAME)/vivado/build/$(PLATFORM_NAME).xsa'
	@echo '  make platform'
	@echo '      Run these commands when XSA is already built in some other folder and no modifications are needed to it.'
	@echo '      XSA should point to $(PLATFORM_NAME).xsa file.'
	@echo ''
	@echo '  make clean '
	@echo '      Command to remove all the generated files.'
	@echo ''

.PHONY: all xsa linux sysroot platform clean

xsa: $(XSA)

$(XSA):
	$(MAKE) -C hw all

linux: $(SW_FILES)

$(SW_FILES): $(XSA)
	$(MAKE) -C sw all

sysroot:
	$(MAKE) -C sw/petalinux sysroot

all platform: $(XSA) $(SW_FILES)
	$(XSCT) -nodisp -sdx $(PLATFORM_SW_SRC)/generate_platform.tcl platform_name "${PLATFORM_NAME}" \
		xsa_path "${XSA}" emu_xsa_path "${HW_EMU_XSA}" platform_out "${PLATFORM_DIR}" \
		boot_dir_path "${BOOT_DIR}" img_dir_path "${IMAGE_DIR}" generate_sw false
	
	@if [ -d $(SW_DIR)/platform/filesystem ]; then cp -rf ${SW_DIR}/platform/filesystem $(PLATFORM_DIR)/${PLATFORM_NAME}/export/${PLATFORM_NAME}/sw/${PLATFORM_NAME}/xrt/; fi
	@echo 'Platform build complete'

clean:
	$(MAKE) -C hw clean
	$(MAKE) -C sw clean
	${RM} -r $(PLATFORM_DIR)
