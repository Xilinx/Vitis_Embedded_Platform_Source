CWD = $(shell readlink -f .)
TOP_DIR = $(CWD)/../../
BUILD_DIR = $(CWD)/build
SYSTEM_XSA = $(CWD)/project-spec/hw-description/system.xsa
PETA_FILES = $(CWD)/images/linux/boot.scr $(CWD)/images/linux/bl31.elf $(CWD)/images/linux/u-boot.elf $(CWD)/images/linux/system.dtb
IMG_ROOTFS_FILES = $(SW_COMP_DIR)/platform/image/Image $(SW_COMP_DIR)/platform/filesystem/rootfs.ext4

include $(TOP_DIR)/platform.mk

check-petalinux:
ifeq ($(PETALINUX),)
	$(error ERROR: 'PETALINUX' variable not set, Please install PetaLinux or use pre-built software images to build the platform. Please refer to build instructions in readme for more details.)
endif

$(XSA):
	$(MAKE) -C $(TOP_DIR) xsa

$(SYSTEM_XSA): $(XSA)
	$(eval XSA_DIR = $(dir $(XSA)))
	petalinux-config --get-hw-description=$(XSA_DIR) --silentconfig

.PHONY: all linux xrt zocl sysroot sw_comp image_rootfs bootimage check-petalinux clean
linux: $(SYSTEM_XSA) $(PETA_FILES)

$(PETA_FILES):
	petalinux-config -c kernel --silentconfig
	petalinux-config -c rootfs --silentconfig
	petalinux-build

xrt:
	petalinux-config -c xrt --silentconfig

zocl:
	petalinux-config -c zocl --silentconfig

sysroot: $(SYSTEM_XSA)
ifeq ($(PETALINUX),)
	$(error ERROR: 'PETALINUX' variable not set, please set correctly and rerun)
else
	mkdir -p $(SYSROOT)
	petalinux-build --sdk
	petalinux-package --sysroot -d $(SYSROOT)
endif

sw_comp: $(SW_COMP_FILES)

$(SW_COMP_FILES): linux
	mkdir -p $(SW_COMP_DIR)
	cp -rf $(PLATFORM_SW_SRC) $(SW_COMP_DIR)
	mkdir -p $(SW_COMP_DIR)/platform/boot
	cp -f images/linux/boot.scr $(SW_COMP_DIR)/platform/image/boot.scr
	cp -f images/linux/bl31.elf $(SW_COMP_DIR)/platform/boot/bl31.elf
	cp -f images/linux/u-boot.elf $(SW_COMP_DIR)/platform/boot/u-boot.elf
	cp -f images/linux/pmufw.elf $(SW_COMP_DIR)/platform/boot/pmufw.elf
	cp -f images/linux/fsbl.elf images/linux/zynqmp_fsbl.elf 2>/dev/null || :
	cp -f images/linux/zynqmp_fsbl.elf $(SW_COMP_DIR)/platform/boot/fsbl.elf
	cp -f images/linux/system.dtb $(SW_COMP_DIR)/platform/image/system.dtb
	cp -f images/linux/system.dtb $(SW_COMP_DIR)/platform/boot/system.dtb

image_rootfs: $(IMG_ROOTFS_FILES)

$(IMG_ROOTFS_FILES): linux
	cp -f images/linux/Image $(SW_COMP_DIR)/platform/image/Image
	mkdir -p $(SW_COMP_DIR)/platform/filesystem
	cp -f images/linux/rootfs.tar.gz $(SW_COMP_DIR)/platform/filesystem/rootfs.tar.gz
	cp -f images/linux/rootfs.ext4 $(SW_COMP_DIR)/platform/filesystem/rootfs.ext4

all: check-petalinux sw_comp image_rootfs

bootimage: linux
	$(info "BOOT image for platforms")
	@if [ -f project-spec/hw-description/$(PLATFORM_NAME).bit ]; then  \
		echo "INFO: BOOT image generation started...";  \
		petalinux-package --force --boot --fsbl images/linux/zynqmp_fsbl.elf --fpga project-spec/hw-description/$(PLATFORM_NAME).bit --u-boot images/linux/u-boot.elf --pmufw images/linux/pmufw.elf --atf images/linux/bl31.elf;  \
		cp -rf images/linux/BOOT.BIN $(SW_COMP_DIR)/platform/;  \
	else  \
		echo "WARNING: "$(PLATFORM_NAME).bit" file not found. Skipping BOOT image generation.";  \
	fi

clean:
	@if [ -f project-spec/hw-description/*.xsa ]; then \
		petalinux-build -x cleanall; \
		${RM} project-spec/hw-description/system.xsa project-spec/hw-description/*.pdi; \
	fi
	${RM} -r images sysroot
	${RM} -r /tmp/xilinx_zcu102_base
	${RM} -r build ip_cache components
