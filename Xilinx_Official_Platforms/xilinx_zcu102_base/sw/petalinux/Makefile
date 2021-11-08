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

SYSTEM_XSA = $(CWD)/project-spec/hw-description/system.xsa
PETA_FILES = $(CWD)/images/linux/boot.scr $(CWD)/images/linux/bl31.elf $(CWD)/images/linux/u-boot.elf $(CWD)/images/linux/system.dtb
IMG_ROOTFS_FILES = $(SW_DIR)/platform/image/Image $(SW_DIR)/platform/filesystem/rootfs.ext4

.PHONY: all linux xrt zocl sysroot sw_comp image_rootfs bootimage check-petalinux clean

$(XSA):
	$(MAKE) -C $(TOP_DIR) xsa

$(SYSTEM_XSA): $(XSA)
	$(eval XSA_DIR = $(dir $(XSA)))
	petalinux-config --get-hw-description=$(XSA_DIR) --silentconfig

linux: check-petalinux $(SYSTEM_XSA) $(PETA_FILES)

$(PETA_FILES):
	petalinux-config -c kernel --silentconfig
	petalinux-config -c rootfs --silentconfig
	petalinux-build

xrt: check-petalinux $(SYSTEM_XSA)
	petalinux-config -c xrt --silentconfig

zocl: check-petalinux $(SYSTEM_XSA)
	petalinux-config -c zocl --silentconfig

sysroot: check-petalinux $(SYSTEM_XSA)
	mkdir -p $(SYSROOT)
	petalinux-build --sdk
	petalinux-package --sysroot -d $(SYSROOT)

sw_comp: check-petalinux $(SW_FILES)

$(SW_FILES): $(SYSTEM_XSA) $(PETA_FILES)
	mkdir -p $(BOOT_DIR) $(IMAGE_DIR)
	cp -f images/linux/boot.scr $(IMAGE_DIR)/boot.scr
	cp -f images/linux/bl31.elf $(BOOT_DIR)/bl31.elf
	cp -f images/linux/u-boot.elf $(BOOT_DIR)/u-boot.elf
	cp -f images/linux/pmufw.elf $(BOOT_DIR)/pmufw.elf
	cp -f images/linux/zynqmp_fsbl.elf images/linux/fsbl.elf
	cp -f images/linux/zynqmp_fsbl.elf $(BOOT_DIR)/fsbl.elf
	cp -f images/linux/system.dtb $(IMAGE_DIR)/system.dtb
	cp -f images/linux/system.dtb $(BOOT_DIR)/system.dtb

image_rootfs: check-petalinux $(IMG_ROOTFS_FILES)

$(IMG_ROOTFS_FILES): $(SYSTEM_XSA) $(PETA_FILES)
	cp -f images/linux/Image $(IMAGE_DIR)/Image
	mkdir -p $(SW_DIR)/platform/filesystem
	cp -f images/linux/rootfs.tar.gz $(SW_DIR)/platform/filesystem/rootfs.tar.gz
	cp -f images/linux/rootfs.ext4 $(SW_DIR)/platform/filesystem/rootfs.ext4

all: check-petalinux $(SW_FILES) $(IMG_ROOTFS_FILES)

bootimage: check-petalinux $(BOOT_IMAGE)

$(BOOT_IMAGE): $(SYSTEM_XSA) $(PETA_FILES)
	$(info "BOOT image for platforms")
	@if [ -f project-spec/hw-description/hw.bit ]; then  \
		echo "INFO: BOOT image generation started...";  \
		petalinux-package --force --boot --fsbl images/linux/fsbl.elf --fpga project-spec/hw-description/hw.bit --u-boot images/linux/u-boot.elf --pmufw images/linux/pmufw.elf --atf images/linux/bl31.elf;  \
		cp -rf images/linux/BOOT.BIN $(SW_DIR)/platform/;  \
	else  \
		echo "WARNING: "hw.bit" file not found. Skipping BOOT image generation.";  \
	fi

clean:
	@if [ -f project-spec/hw-description/*.xsa ]; then \
		petalinux-build -x cleanall; \
		${RM} project-spec/hw-description/system.xsa project-spec/hw-description/*.pdi; \
	fi
	${RM} -r images sysroot
	${RM} -r /tmp/xilinx_zcu102_base-2021.2
	${RM} -r build ip_cache components
