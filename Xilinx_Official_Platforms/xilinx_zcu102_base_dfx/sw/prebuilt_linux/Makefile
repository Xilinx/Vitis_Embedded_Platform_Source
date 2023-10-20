#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

CWD = $(shell readlink -f .)
TOP_DIR = $(CWD)/../../
include $(TOP_DIR)/platform.mk

SYSTEM_USER_DTSI = $(CWD)/user_dts/system-user.dtsi
#SYSTEM_CONF_DTS  =  $(CWD)/user_dts/system-conf.dtsi
BIT_FILE         = $(SW_DIR)/$(PLATFORM_NAME).bit

.PHONY: check-vitis check-prebuilt all sw_comp dtb bootimage clean

$(XSA):
	$(MAKE) -C $(TOP_DIR) xsa

dtb: $(DTB_FILE)

$(DTB_FILE): check-vitis $(XSA)
	$(info "Generating SW Artifacts...")
	@if [ ! -d $(BOOT_DIR) ]; then mkdir -p $(BOOT_DIR); fi
	@mkdir -p $(SW_DIR)/tmp
	$(info "DTB generation started using XSCT")
	$(info $(XSCT) -eval "createdts -hw $(XSA) -git-url https://gitenterprise.xilinx.com/Linux/device-tree-xlnx.git -git-branch xlnx_rel_v2023.2 -board $(BOARD) -platform $(PLATFORM) -out $(SW_DIR)/tmp -dtsi $(SYSTEM_USER_DTSI) -compile")
	@$(XSCT) -eval "createdts -hw $(XSA) -git-url https://gitenterprise.xilinx.com/Linux/device-tree-xlnx.git -git-branch xlnx_rel_v2023.2 -board $(BOARD) -platform $(PLATFORM) -out $(SW_DIR)/tmp -dtsi $(SYSTEM_USER_DTSI) -compile"
	$(eval BSP_PATH = $(SW_DIR)/tmp/$(PLATFORM)/$(CORE)/device_tree_domain/bsp/)
	@if [ ! -f $(BSP_PATH)/system.dtb ]; then echo -e "ERROR: Device tree generation failed\n"; exit 1; fi
	cp $(BSP_PATH)/system.dtb $(DTB_FILE) -v
	@rm -rf $(SW_DIR)/tmp

sw_comp: $(SW_FILES)

$(SW_FILES): $(DTB_FILE)
	mkdir -p $(IMAGE_DIR)
	cp -f $(PREBUILT_LINUX_PATH)/boot.scr ${IMAGE_DIR}/boot.scr
	$(foreach BOOT_FILE,$(BOOT_FILES),cp -f $(PREBUILT_LINUX_PATH)/$(BOOT_FILE) $(BOOT_DIR) ;)
	
	# Generate fsbl, pmufw elf files
	$(XSCT) -nodisp -sdx $(PLATFORM_SW_SRC)/generate_platform.tcl platform_name "${PLATFORM_NAME}" \
		static_xsa_path "${XSA}" rp_xsa_path "${XSA}" emu_xsa_path "${HW_EMU_XSA}" \
		platform_out "${PLATFORM_DIR}" boot_dir_path "${BOOT_DIR}" img_dir_path "${IMAGE_DIR}" generate_sw true
	$(eval BOOT_ARTIFACTS = ${PLATFORM_DIR}/${PLATFORM_NAME}/export/${PLATFORM_NAME}/sw/${PLATFORM_NAME}/boot)
	cp -rf ${BOOT_ARTIFACTS}/*.elf ${BOOT_DIR} 2>/dev/null || :
	${RM} -r ${PLATFORM_DIR}
	
all: check-vitis check-prebuilt $(SW_FILES) $(BOOT_IMAGE)

$(BIT_FILE): $(XSA)
	mkdir -p $(SW_DIR)
	cp -f $(XSA) $(SW_DIR)/system.xsa
	@echo "openhw $(SW_DIR)/system.xsa" >> $(SW_DIR)/extract
	$(XSCT) $(SW_DIR)/extract

bootimage: $(BOOT_IMAGE)

$(BOOT_IMAGE): $(BIT_FILE) $(SW_FILES)
	$(info "BOOT image for platforms")
	$(BOOTGEN) -arch zynqmp -image $(CWD)/bootgen.bif -o $(BOOT_IMAGE) -w;

clean:
	${RM} -r $(SW_DIR)
