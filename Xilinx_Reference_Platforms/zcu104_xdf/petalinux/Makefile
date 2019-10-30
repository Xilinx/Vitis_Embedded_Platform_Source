BOOT_FSBL_IMAGE = images/linux/zynqmp_fsbl.elf
BOOT_UBOOT_IMAGE = images/linux/u-boot.elf
BOOT_ATF_IMAGE = images/linux/bl31.elf
BOOT_PMUFW_IMAGE = images/linux/pmufw.elf
BOOT_IMAGE = images/linux/boot.bin
KERNEL_IMAGE = images/linux/image.ub
VIVADO_IMAGE = ../platform_repo/tmp/xsa
SDX_ROOT = ../platform_repo/tmp/sw_components
SDX_GENERICS = ./
SD_DIR = ../platform_repo/SD-Image
BOARD_IP = 10.0.0.104

.PHONY: linux bootimage stresstest fsbl dts build-dts dump-dts hw-description ssh sdk refresh-hw

all: linux bootimage

dts: build-dts package bootimage

rootfs: build-rootfs package bootimage

hw-description:
	petalinux-config --get-hw-description=${VIVADO_IMAGE}

refresh-hw:
	petalinux-config --get-hw-description=${VIVADO_IMAGE} --silentconfig

fsbl:
	petalinux-build -c bootloader

clean:
	petalinux-build -x cleanall
	$(RM) -r images/linux/*

ultraclean: clean
	$(RM) -r build ip_cache components

linux:
	petalinux-build

build-dts:
	petalinux-build -c device-tree

dump-dts:
	dtc -I dtb -O dts -o dump.dts images/linux/system.dtb

build-rootfs:
	petalinux-build -c rootfs

package:
	petalinux-build -x package

bootimage:
	petalinux-package --boot --force --fsbl ${BOOT_FSBL_IMAGE} --u-boot=${BOOT_UBOOT_IMAGE} -o ${BOOT_IMAGE}

sd:
	mkdir -p ${SD_DIR}
	cp ${BOOT_IMAGE} ${SD_DIR}
	cp ${KERNEL_IMAGE} ${SD_DIR}

ssh:
	scp -o StrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" ${KERNEL_IMAGE} ${BOOT_IMAGE} root@${BOARD_IP}:/media/card

sw_comp:
	mkdir -p ${SDX_ROOT}/boot
	cp ${BOOT_FSBL_IMAGE} ${SDX_ROOT}/boot
	touch ${SDX_ROOT}/boot/generic.readme
	cp ${BOOT_UBOOT_IMAGE} ${SDX_ROOT}/boot
	cp ${BOOT_ATF_IMAGE} ${SDX_ROOT}/boot
	cp ${BOOT_PMUFW_IMAGE} ${SDX_ROOT}/boot
	cp ${SDX_GENERICS}/petalinux.bif ${SDX_ROOT}/boot
	mkdir -p ${SDX_ROOT}/image
	cp ${KERNEL_IMAGE} ${SDX_ROOT}/image

sdk:
	petalinux-build --sdk

