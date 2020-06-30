CPU_ARCH=a9
OUTPUT=../platform_repo/tmp/sw_components/
SYSROOT=../platform_repo/sysroot
all: refresh_hw xrt zocl kernel_config rootfs_config linux sw_comp bootimage
export COMMON_RFS_KRNL_SYSROOT = TRUE
.phony: all

refresh_hw:
	petalinux-config --get-hw-description=${XSA_DIR} --silentconfig

sw_config: xrt zocl kernel_config rootfs_config

xrt:
	petalinux-config -c xrt --silentconfig

zocl:
	petalinux-config -c zocl --silentconfig

kernel_config:
	petalinux-config -c kernel --silentconfig

rootfs_config:
	petalinux-config -c rootfs --silentconfig

linux:
	petalinux-build

ifeq ($(COMMON_RFS_KRNL_SYSROOT), TRUE)
sw_comp:
	mkdir -p $(OUTPUT)
	cp -rf $(XSA_DIR)/src $(OUTPUT)
	mkdir -p ${OUTPUT}/src/boot
	cp -f images/linux/boot.scr ${OUTPUT}/src/${CPU_ARCH}/xrt/image/boot.scr
	cp -f images/linux/system.dtb ${OUTPUT}/src/${CPU_ARCH}/xrt/image/system.dtb
	cp -f images/linux/u-boot.elf ${OUTPUT}/src/boot/u-boot.elf
	cp -f images/linux/zynq_fsbl.elf ${OUTPUT}/src/boot/fsbl.elf
else
sw_comp:
	mkdir -p $(OUTPUT)
	cp -rf $(XSA_DIR)/src $(OUTPUT)
	mkdir -p ${OUTPUT}/src/boot
	cp -f images/linux/uImage ${OUTPUT}/src/${CPU_ARCH}/xrt/image/uImage
	mkdir -p ${OUTPUT}/src/${CPU_ARCH}/xrt/filesystem
	cp -f images/linux/boot.scr ${OUTPUT}/src/${CPU_ARCH}/xrt/image/boot.scr
	cp -f images/linux/rootfs.tar.gz ${OUTPUT}/src/${CPU_ARCH}/xrt/filesystem/rootfs.tar.gz
	cp -f images/linux/rootfs.ext4 ${OUTPUT}/src/${CPU_ARCH}/xrt/filesystem/rootfs.ext4
	cp -f images/linux/rootfs.cpio.gz.u-boot ${OUTPUT}/src/${CPU_ARCH}/xrt/filesystem/rootfs.cpio.gz.u-boot

	cp -f images/linux/system.dtb ${OUTPUT}/src/${CPU_ARCH}/xrt/image/system.dtb
	cp -f images/linux/u-boot.elf ${OUTPUT}/src/boot/u-boot.elf
	cp -f images/linux/zynq_fsbl.elf ${OUTPUT}/src/boot/fsbl.elf
endif

bootimage:
	@echo "No BOOT image for non-PR platforms"
	petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --fpga project-spec/hw-description/$(PLATFORM).bit --u-boot images/linux/u-boot.elf
	cp -rf images/linux/BOOT.BIN ${OUTPUT}/src/${CPU_ARCH}/

sysroot:
	mkdir -p ${SYSROOT}
	petalinux-build --sdk
	petalinux-package --sysroot -d ${SYSROOT}

clean:
	petalinux-build -x cleanall
	$(RM) -r images/linux/*

ultraclean: clean
	${RM} -r build ip_cache components

