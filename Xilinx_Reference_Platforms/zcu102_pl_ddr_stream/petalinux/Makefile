BOOT_FSBL_IMAGE = images/linux/zynqmp_fsbl.elf
BOOT_BIT_IMAGE = ../bit/zcu102_pl_ddr_wrapper.bit
BOOT_UBOOT_IMAGE = images/linux/u-boot.elf
BOOT_ATF_IMAGE = images/linux/bl31.elf
BOOT_PMUFW_IMAGE = images/linux/pmufw.elf
BOOT_IMAGE = images/linux/boot.bin
KERNEL_IMAGE = images/linux/image.ub
VIVADO_IMAGE = ../dsa/
SDX_ROOT = ../sw_platform
SDX_GENERICS = ../generics/linux
SD_DIR = /media/robarm/BOOT/
BOARD_IP = 10.0.0.102

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

ultraclean:
	$(RM) -r build components images

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
	petalinux-package --boot --force --fsbl ${BOOT_FSBL_IMAGE} --fpga ${BOOT_BIT_IMAGE} --u-boot=${BOOT_UBOOT_IMAGE} -o ${BOOT_IMAGE}

sd:
	cp ${BOOT_IMAGE} ${SD_DIR}
	cp images/linux/image.ub ${SD_DIR}

ssh:
	scp -o StrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" ${KERNEL_IMAGE} ${BOOT_IMAGE} root@${BOARD_IP}:/media/card

sdx:
	mkdir -p ${SDX_ROOT}/boot
	cp ${BOOT_FSBL_IMAGE} ${SDX_ROOT}/boot
	touch ${SDX_ROOT}/boot/generic.readme
	cp ${BOOT_UBOOT_IMAGE} ${SDX_ROOT}/boot
	cp ${BOOT_ATF_IMAGE} ${SDX_ROOT}/boot
	cp ${BOOT_PMUFW_IMAGE} ${SDX_ROOT}/boot
	cp ${SDX_GENERICS}/linux.bif ${SDX_ROOT}/boot
	mkdir -p ${SDX_ROOT}/image
	cp ${KERNEL_IMAGE} ${SDX_ROOT}/image

sdk:
	petalinux-build --sdk
