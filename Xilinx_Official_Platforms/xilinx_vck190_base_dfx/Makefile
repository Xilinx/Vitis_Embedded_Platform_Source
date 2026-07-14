#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

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

	vitis -s $(PLATFORM_SW_SRC)/generate_platform.py --platform_name $(PLATFORM_NAME) --static_xsa_path $(STATIC_XSA) --emu_xsa_path $(HW_EMU_XSA) --boot_dir_path $(BOOT_DIR)  --platform_out $(PLATFORM_DIR) --img_dir_path $(IMAGE_DIR) --rp_xsa_path $(RP_XSA) --user_dtsi $(USER_DTSI)

	$(info "Generating BOOT image for platforms")
	cp -f $(PLATFORM_DIR)/xilinx_vck190_base_dfx_202610_1/hw/linux_dt/system.dtb $(BOOT_DIR)
	$(BOOTGEN) -arch versal -image $(TOP_DIR)/sw/prebuilt_linux/bootgen.bif -o $(BOOT_IMAGE) -w;

	@echo 'Platform build started'
	vitis -s $(PLATFORM_SW_SRC)/build_platform.py --platform_name $(PLATFORM_NAME) --platform_out $(PLATFORM_DIR)  --boot_image $(BOOT_IMAGE)


	@if [ -d $(SW_DIR)/platform/filesystem ]; then cp -rf ${SW_DIR}/platform/filesystem $(PLATFORM_DIR)/${PLATFORM_NAME}/export/${PLATFORM_NAME}/sw/${PLATFORM_NAME}/xrt/; fi
	@echo 'Platform build complete'

clean:
	$(MAKE) -C hw clean
	$(MAKE) -C sw clean
	${RM} -r $(PLATFORM_DIR)
