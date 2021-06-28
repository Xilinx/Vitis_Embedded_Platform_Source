export PLATFORM = xilinx_zc706_base
export CPU_ARCH = a9
export BOARD = zc706
export CORE = ps7_cortexa9_0
export SW_COMP_FILES = ${SW_COMP_DIR}/platform/image/boot.scr ${SW_COMP_DIR}/platform/boot/u-boot.elf ${SW_COMP_DIR}/platform/image/system.dtb

TOP_DIR ?= $(shell readlink -f .)
include $(TOP_DIR)/../common/makefiles/common.mk
