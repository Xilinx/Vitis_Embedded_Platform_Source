.EXPORT_ALL_VARIABLES:
CWD              = $(shell readlink -f .)
VERSION          = 202030_1
VER              = 202030.1
XSA_DIR         ?= $(CWD)/hw/build
SYSROOT          = $(CWD)/sw/build/sysroot
OUTPUT_PATH      = $(CWD)/platform_repo
SW_COMP_DIR      = $(OUTPUT_PATH)/tmp
XSCT             = $(XILINX_VITIS)/bin/xsct
PLATFORM_NAME    = $(PLATFORM)_$(VERSION)
XSA              = $(XSA_DIR)/$(PLATFORM_NAME).xsa
PLATFORM_SW_SRC  = $(CWD)/platform
XSCT_SCRIPTS     = $(CWD)/../common/xsct_scripts
BOOT_FILES       = $(BOOT_FILES_PATH)
PRE_SYNTH       ?= FALSE

COMMON_RFS_KRNL_SYSROOT ?= TRUE
