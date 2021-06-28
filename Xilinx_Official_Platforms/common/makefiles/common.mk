.EXPORT_ALL_VARIABLES:
VERSION          = 202110_1
VER              = 202110.1
XSA_DIR         ?= $(TOP_DIR)/hw/build
SYSROOT          = $(TOP_DIR)/sw/petalinux/sysroot
OUTPUT_PATH      = $(TOP_DIR)/platform_repo
SW_COMP_DIR      = $(OUTPUT_PATH)/tmp
XSCT             = $(XILINX_VITIS)/bin/xsct
PLATFORM_NAME    = $(PLATFORM)_$(VERSION)
XSA             ?= $(XSA_DIR)/$(PLATFORM_NAME).xsa
PLATFORM_SW_SRC  = $(TOP_DIR)/platform
XSCT_SCRIPTS     = $(TOP_DIR)/../common/xsct_scripts
PRE_SYNTH       ?= TRUE
