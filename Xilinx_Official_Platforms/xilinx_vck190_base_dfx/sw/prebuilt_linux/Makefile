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

CWD = $(shell readlink -f .)
TOP_DIR = $(CWD)/../../
include $(TOP_DIR)/platform.mk

SYSTEM_USER_DTSI = $(CWD)/user_dts/system-user.dtsi
SYSTEM_CONF_DTS  = $(CWD)/user_dts/system-conf.dtsi
PDI_FILE         = $(SW_DIR)/static.pdi

.PHONY: check-vitis check-prebuilt all sw_comp dtb bootimage clean

$(STATIC_XSA):
	$(MAKE) -C $(TOP_DIR) xsa

dtb: $(DTB_FILE)

$(DTB_FILE): $(STATIC_XSA)
	$(info "Generating SW Artifacts...")
	@if [ ! -d $(BOOT_DIR) ]; then mkdir -p $(BOOT_DIR); fi
	mkdir -p $(SW_DIR)/tmp
	$(info "DTB generation started using XSCT")
	$(XSCT) -eval "createdts -hw $(STATIC_XSA) -git-url https://github.com/Xilinx/device-tree-xlnx.git -git-branch xlnx_rel_v2022.1 -board $(BOARD) -platform $(PLATFORM) -out $(SW_DIR)/tmp"
	$(eval BSP_PATH = $(SW_DIR)/tmp/$(PLATFORM)/$(CORE)/device_tree_domain/bsp/)
	cp -rf  $(SYSTEM_CONF_DTS) $(BSP_PATH)
	cp -rf  $(SYSTEM_USER_DTSI) $(BSP_PATH)
	@if [ -f $(SYSTEM_USER_DTSI) ]; then echo "#include \"system-user.dtsi\"" >> $(BSP_PATH)/system-top.dts; fi
	cd $(BSP_PATH) && \
	cpp -Iinclude -E -P -undef -D__DTS__ -x assembler-with-cpp ./system-top.dts | $(DTC) -I dts -O dtb -o $(DTB_FILE) - && cd -
	rm -rf $(SW_DIR)/tmp

sw_comp: $(SW_FILES)

$(SW_FILES): $(DTB_FILE)
	mkdir -p $(IMAGE_DIR)
	cp -f $(PREBUILT_LINUX_PATH)/boot.scr ${IMAGE_DIR}/boot.scr
	$(foreach BOOT_FILE,$(BOOT_FILES),cp -f $(PREBUILT_LINUX_PATH)/$(BOOT_FILE) $(BOOT_DIR) ;)

all: check-vitis check-prebuilt $(SW_FILES) $(BOOT_IMAGE)

$(PDI_FILE): $(STATIC_XSA)
	mkdir -p $(SW_DIR)
	cp -f $(STATIC_XSA) $(SW_DIR)/system.xsa
	@echo "openhw $(SW_DIR)/system.xsa" >> $(SW_DIR)/extract
	$(XSCT) $(SW_DIR)/extract

bootimage: $(BOOT_IMAGE)

$(BOOT_IMAGE): $(PDI_FILE) $(SW_FILES)
	$(info "BOOT image for platforms")
	$(BOOTGEN) -arch versal -image $(CWD)/bootgen.bif -o $(BOOT_IMAGE) -w;

clean:
	${RM} -r $(SW_DIR)
