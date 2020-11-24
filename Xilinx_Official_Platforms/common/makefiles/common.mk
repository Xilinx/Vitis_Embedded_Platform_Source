export CWD              = $(shell readlink -f .)
export VERSION          = 202020_1
export VER              = 202020.1
export XSA_DIR          = $(CWD)/hw/build
export SYSROOT          = $(CWD)/sw/build/sysroot
export OUTPUT_PATH      = $(CWD)/platform_repo
export SW_COMP_DIR      = $(OUTPUT_PATH)/tmp
export XSCT             = $(XILINX_VITIS)/bin/xsct
export PLATFORM_NAME    = $(PLATFORM)_$(VERSION)
export XSA              = $(XSA_DIR)/$(PLATFORM_NAME).xsa
export PLATFORM_SW_SRC  = $(CWD)/platform
export XSCT_SCRIPTS     = $(CWD)/../common/xsct_scripts
export BOOT_FILES       = $(BOOT_FILES_PATH)
export PRE_SYNTH        ?= FALSE

export COMMON_RFS_KRNL_SYSROOT ?= TRUE
