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
SYSTEM_CONF_DTS  =  $(CWD)/user_dts/system-conf.dtsi
BIT_FILE         = $(SW_DIR)/hw.bit

.PHONY: check-vitis check-prebuilt all sw_comp dtb bootimage clean

$(XSA):
	$(MAKE) -C $(TOP_DIR) xsa

dtb: $(DTB_FILE)

$(DTB_FILE): $(XSA)
	$(info "generating sw artifacts...")
	@if [ ! -d $(BOOT_DIR) ]; then mkdir -p $(BOOT_DIR); fi
	mkdir -p $(SW_DIR)/tmp/dt
	git clone https://github.com/Xilinx/device-tree-xlnx.git -b xlnx_rel_v2021.2 $(SW_DIR)/tmp/dt
	$(XSCT) -nodisp dtb_generator.tcl $(PLATFORM) $(SW_DIR)/tmp/dt $(XSA) $(BOARD) $(CORE) $(SW_DIR)/tmp $(ZOCL_AUTO_GENERATE)
	$(eval BSP_PATH = $(SW_DIR)/tmp/Workspace/$(PLATFORM)/$(CORE)/device_tree_domain/bsp/)
	$(eval BOOT_ARTIFACTS = $(SW_DIR)/tmp/Workspace/$(PLATFORM)/export/$(PLATFORM)/sw/$(PLATFORM)/boot)
	cp -rf  $(SYSTEM_CONF_DTS) $(BSP_PATH)
	cp -rf  $(SYSTEM_USER_DTSI) $(BSP_PATH)
	@if [ -f $(SYSTEM_USER_DTSI) ]; then echo "#include \"system-user.dtsi\"" >> $(BSP_PATH)/system-top.dts; fi
	cd $(BSP_PATH) && \
	cpp -Iinclude -E -P -undef -D__DTS__ -x assembler-with-cpp ./system-top.dts | $(DTC) -I dts -O dtb -o $(DTB_FILE) - && cd -
	cp -rf $(BOOT_ARTIFACTS)/*.elf $(SW_DIR)/platform/boot/ 2>/dev/null || :
	rm -rf $(SW_DIR)/tmp

sw_comp: $(SW_FILES)

$(SW_FILES): $(DTB_FILE)
	mkdir -p $(IMAGE_DIR)
	cp -f $(PREBUILT_LINUX_PATH)/boot.scr ${IMAGE_DIR}/boot.scr
	$(foreach BOOT_FILE,$(BOOT_FILES),cp -f $(PREBUILT_LINUX_PATH)/$(BOOT_FILE) $(BOOT_DIR) ;)

all: check-vitis check-prebuilt $(SW_FILES)

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
