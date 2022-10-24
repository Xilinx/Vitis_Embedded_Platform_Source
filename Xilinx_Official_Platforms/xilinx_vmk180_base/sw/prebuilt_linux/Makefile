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

CWD = $(shell readlink -f .)
TOP_DIR = $(CWD)/../../
include $(TOP_DIR)/platform.mk

SYSTEM_USER_DTSI = $(CWD)/user_dts/system-user.dtsi
#SYSTEM_CONF_DTS  = $(CWD)/user_dts/system-conf.dtsi
PDI_FILE         = $(SW_DIR)/hw.pdi

.PHONY: check-vitis check-prebuilt all sw_comp dtb bootimage clean

$(XSA):
	$(MAKE) -C $(TOP_DIR) xsa

dtb: $(DTB_FILE)

$(DTB_FILE): $(XSA)
	$(info "Generating SW Artifacts...")
	@if [ ! -d $(BOOT_DIR) ]; then mkdir -p $(BOOT_DIR); fi
	mkdir -p $(SW_DIR)/tmp
	$(info "DTB generation started using XSCT")
	$(info $(XSCT) -eval "createdts -hw $(XSA) -git-url https://github.com/Xilinx/device-tree-xlnx.git -git-branch xlnx_rel_v2022.2 -board $(BOARD) -platform $(PLATFORM) -out $(SW_DIR)/tmp -dtsi $(SYSTEM_USER_DTSI) -compile")
	@$(XSCT) -eval "createdts -hw $(XSA) -git-url https://github.com/Xilinx/device-tree-xlnx.git -git-branch xlnx_rel_v2022.2 -board $(BOARD) -platform $(PLATFORM) -out $(SW_DIR)/tmp -dtsi $(SYSTEM_USER_DTSI) -compile" && echo -e "\n***Device Tree generation Successful!\n" || echo -e "\n"
	$(eval BSP_PATH = $(SW_DIR)/tmp/$(PLATFORM)/$(CORE)/device_tree_domain/bsp/)
	@if [ ! -f $(BSP_PATH)/system.dtb ]; then echo -e "***Device tree generation failed\n"; exit 1; fi
	cp $(BSP_PATH)/system.dtb $(DTB_FILE) -v
	rm -rf $(SW_DIR)/tmp

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
