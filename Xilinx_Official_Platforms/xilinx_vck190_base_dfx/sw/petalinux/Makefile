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

SYSTEM_XSA = $(CWD)/project-spec/hw-description/system.xsa
PETA_FILES = $(CWD)/images/linux/boot.scr $(CWD)/images/linux/bl31.elf $(CWD)/images/linux/u-boot.elf $(CWD)/images/linux/system.dtb
IMG_ROOTFS_FILES = $(SW_DIR)/platform/image/Image $(SW_DIR)/platform/filesystem/rootfs.ext4

.PHONY: all linux xrt zocl sysroot sw_comp image_rootfs bootimage check-petalinux clean

$(STATIC_XSA):
	$(MAKE) -C $(TOP_DIR) xsa

$(SYSTEM_XSA): $(STATIC_XSA)
	$(eval XSA_DIR = $(dir $(STATIC_XSA)))
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
	@if [ ! -d $(SYSROOT) ]; then mkdir -p $(SYSROOT); fi
	petalinux-build --sdk 
	petalinux-package --sysroot -d $(SYSROOT)

sw_comp: check-petalinux $(SW_FILES)

$(SW_FILES): $(SYSTEM_XSA) $(PETA_FILES)
	mkdir -p $(BOOT_DIR) $(IMAGE_DIR)
	cp -f images/linux/boot.scr $(IMAGE_DIR)/boot.scr
	cp -f images/linux/bl31.elf $(BOOT_DIR)/bl31.elf
	cp -f images/linux/u-boot.elf $(BOOT_DIR)/u-boot.elf
	cp -f images/linux/system.dtb $(BOOT_DIR)/system.dtb

image_rootfs: check-petalinux $(IMG_ROOTFS_FILES)

$(IMG_ROOTFS_FILES): $(SYSTEM_XSA) $(PETA_FILES)
	cp -f images/linux/Image $(IMAGE_DIR)
	mkdir -p $(SW_DIR)/platform/filesystem
	cp -f images/linux/rootfs.tar.gz $(SW_DIR)/platform/filesystem/rootfs.tar.gz
	cp -f images/linux/rootfs.ext4 $(SW_DIR)/platform/filesystem/rootfs.ext4

all: check-petalinux $(SW_FILES) $(IMG_ROOTFS_FILES) $(BOOT_IMAGE)

bootimage: check-vitis check-petalinux $(BOOT_IMAGE)

$(BOOT_IMAGE): $(SYSTEM_XSA) $(PETA_FILES)
	$(info "BOOT image for platforms")
	@if [ -f project-spec/hw-description/static.pdi ]; then \
		echo "INFO: BOOT image generation started...";  \
		petalinux-package --boot --u-boot --plm no --psmfw no --qemu-rootfs no --force && cd -; \
		cp -rf images/linux/BOOT.BIN $(BOOT_DIR);  \
	else  \
		echo "WARNING: "static.pdi" file not found. Skipping BOOT image generation.";  \
	fi	

clean:
	@if [ -f project-spec/hw-description/*.xsa ]; then \
		petalinux-build -x cleanall; \
		${RM} project-spec/hw-description/system.xsa project-spec/hw-description/*.pdi; \
	fi
	${RM} -r images sysroot
	${RM} -r $(SW_DIR)
	${RM} -r /tmp/xilinx_vck190_base_dfx-2022.1
	${RM} -r build ip_cache components
