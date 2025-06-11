#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

CWD = $(shell readlink -f .)
TOP_DIR = $(CWD)/../../
include $(TOP_DIR)/platform.mk

SYSTEM_USER_DTSI = $(CWD)/user_dts/system-user.dtsi
#SYSTEM_CONF_DTS  = $(CWD)/user_dts/system-conf.dtsi
PDI_FILE         = $(SW_DIR)/hw.pdi
DTB_PATH         = $(CWD)/dtb_gen

.PHONY: check-vitis check-prebuilt all sw_comp dtb bootimage clean

$(XSA):
	$(MAKE) -C $(TOP_DIR) xsa

dtb: $(DTB_FILE)

$(DTB_FILE): check-vitis $(XSA)
	$(info "Generating SW Artifacts...")
	@if [ ! -d $(BOOT_DIR) ]; then mkdir -p $(BOOT_DIR); fi
	$(info "DTB generation started using stdgen+lopper")

	$(MAKE) -C dtb_gen all

	@if [ ! -f  $(DTB_PATH)/system.dtb ]; then echo -e "ERROR: Device tree generation failed\n"; exit 1; fi
	cp $(DTB_PATH)/system.dtb $(DTB_FILE) -v

sw_comp: $(SW_FILES)

$(SW_FILES): $(DTB_FILE)
	mkdir -p $(IMAGE_DIR)
	cp -f $(PREBUILT_LINUX_PATH)/boot.scr ${IMAGE_DIR}/boot.scr
	$(foreach BOOT_FILE,$(BOOT_FILES),cp -f $(PREBUILT_LINUX_PATH)/$(BOOT_FILE) $(BOOT_DIR) ;)

all: check-vitis check-prebuilt $(SW_FILES)

$(PDI_FILE): $(XSA)
	mkdir -p $(SW_DIR)
	cp -f $(XSA) $(SW_DIR)/system.xsa
	@echo "openhw $(SW_DIR)/system.xsa" >> $(SW_DIR)/extract
	$(XSCT) $(SW_DIR)/extract

bootimage: $(BOOT_IMAGE)

$(BOOT_IMAGE): $(PDI_FILE) $(SW_FILES)
	$(info "BOOT image for platforms")
	$(BOOTGEN) -arch versal -image $(CWD)/bootgen.bif -o $(BOOT_IMAGE) -w;

clean:
	${RM} -r $(SW_DIR)
	${RM} -r $(PLATFORM_DIR)
	$(MAKE) -C dtb_gen clean ;

