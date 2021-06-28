export PLATFORM = xilinx_vck190_base
export CPU_ARCH = a72
export BOARD = versal-vck190-reva-x-ebm-01-reva
export CORE = psv_cortexa72_0
export SW_COMP_FILES = ${SW_COMP_DIR}/platform/image/boot.scr ${SW_COMP_DIR}/platform/boot/u-boot.elf ${SW_COMP_DIR}/platform/boot/system.dtb

TOP_DIR ?= $(shell readlink -f .)
include $(TOP_DIR)/../common/makefiles/common.mk
