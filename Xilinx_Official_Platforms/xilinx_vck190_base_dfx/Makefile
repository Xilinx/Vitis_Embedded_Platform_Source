#
# (c) Copyright 2021 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# 
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
#

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
	@echo '  *************************************************************************************************************'
	@echo '  *                                                                                                           *'
	@echo '  *  Please download Prebuilt Image using the following URL : 																								 *'
	@echo '  *                                                                                                           *'
	@echo '  *  https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-platforms.html *'
	@echo '  *                                                                                                           *'
	@echo '  *************************************************************************************************************'
	@echo ''
	@echo '  make linux XSA=/home/user/$(PLATFORM_NAME)/vivado/build/$(PLATFORM_NAME).xsa'
	@echo '  make platform'
	@echo '      Run these commands when XSA is already built in some other folder and no modifications are needed to it.'
	@echo '      XSA should point to $(PLATFORM_NAME).xsa file.'
	@echo ''
	@echo '  make clean '
	@echo '      Command to remove all the generated files.'
	@echo ''

.PHONY: all xsa linux platform clean

xsa: $(STATIC_XSA)

$(STATIC_XSA):
	$(MAKE) -C hw all

linux: $(SW_FILES)

$(SW_FILES): $(STATIC_XSA)
	$(MAKE) -C sw all

all platform: $(STATIC_XSA) $(RP_XSA) $(SW_FILES)
	$(XSCT) -nodisp -sdx $(PLATFORM_SW_SRC)/generate_platform.tcl platform_name "${PLATFORM_NAME}" static_xsa_path "${STATIC_XSA}" rp_xsa_path "${RP_XSA}" emu_xsa_path "${HW_EMU_XSA}" platform_out "${PLATFORM_DIR}" boot_dir_path "${BOOT_DIR}" img_dir_path "${IMAGE_DIR}"
	@if [ -d $(SW_DIR)/platform/filesystem ]; then cp -rf ${SW_DIR}/platform/filesystem $(PLATFORM_DIR)/${PLATFORM_NAME}/export/${PLATFORM_NAME}/sw/${PLATFORM_NAME}/xrt/; fi
	@echo 'Platform build complete'

clean:
	$(MAKE) -C hw clean
	$(MAKE) -C sw clean
	${RM} -r $(PLATFORM_DIR)
