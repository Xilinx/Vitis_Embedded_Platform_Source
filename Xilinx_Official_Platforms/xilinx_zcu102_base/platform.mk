export PLATFORM = xilinx_zcu102_base
export CPU_ARCH = a53
export BOARD = zcu102-rev1.0
export CORE = psu_cortexa53_0
export SW_COMP_FILES = ${SW_COMP_DIR}/platform/image/boot.scr ${SW_COMP_DIR}/platform/boot/u-boot.elf ${SW_COMP_DIR}/platform/image/system.dtb

TOP_DIR ?= $(shell readlink -f .)
include $(TOP_DIR)/../common/makefiles/common.mk
