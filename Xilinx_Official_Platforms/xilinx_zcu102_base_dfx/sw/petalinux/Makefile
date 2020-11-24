refresh_hw:
	petalinux-config --get-hw-description=${XSA_DIR} --silentconfig

kernel_config:
	petalinux-config -c kernel --silentconfig

rootfs_config:
	petalinux-config -c rootfs --silentconfig

linux:
	petalinux-build

xrt:
	petalinux-config -c xrt --silentconfig

zocl:
	petalinux-config -c zocl --silentconfig

sysroot:
	mkdir -p ${SYSROOT}
	petalinux-build --sdk
	petalinux-package --sysroot -d ${SYSROOT}

sw_comp:
	mkdir -p $(SW_COMP_DIR)
	cp -rf $(PLATFORM_SW_SRC) ${SW_COMP_DIR}
	cp -f images/linux/boot.scr ${SW_COMP_DIR}/platform/image/boot.scr
	cp -f images/linux/bl31.elf ${SW_COMP_DIR}/platform/boot/bl31.elf
	cp -f images/linux/u-boot.elf ${SW_COMP_DIR}/platform/boot/u-boot.elf
	cp -f images/linux/pmufw.elf ${SW_COMP_DIR}/platform/boot/pmufw.elf
	cp -f images/linux/fsbl.elf images/linux/zynqmp_fsbl.elf 2>/dev/null || :
	cp -f images/linux/zynqmp_fsbl.elf ${SW_COMP_DIR}/platform/boot/fsbl.elf
	cp -f images/linux/system.dtb ${SW_COMP_DIR}/platform/image/system.dtb

image_rootfs:
	cp -f images/linux/Image ${SW_COMP_DIR}/platform/image/Image
	mkdir -p ${SW_COMP_DIR}/platform/filesystem
	cp -f images/linux/rootfs.tar.gz ${SW_COMP_DIR}/platform/filesystem/rootfs.tar.gz
	cp -f images/linux/rootfs.ext4 ${SW_COMP_DIR}/platform/filesystem/rootfs.ext4

all: refresh_hw kernel_config rootfs_config linux sw_comp image_rootfs bootimage

bootimage:
	$(info "BOOT image for platforms")
	@if [ -f project-spec/hw-description/$(PLATFORM_NAME).bit ]; then  \
		echo "INFO: BOOT image genration started...";  \
		petalinux-package --force --boot --fsbl images/linux/zynqmp_fsbl.elf --fpga project-spec/hw-description/$(PLATFORM_NAME).bit --u-boot images/linux/u-boot.elf --pmufw images/linux/pmufw.elf --atf images/linux/bl31.elf;  \
		cp -rf images/linux/BOOT.BIN ${SW_COMP_DIR}/platform/image/;  \
		cp -rf images/linux/BOOT.BIN ${SW_COMP_DIR}/platform/;  \
	else  \
		echo "WARNING: "$(PLATFORM_NAME).bit" file not found. Skipping BOOT image generation.";  \
	fi
