#
# (c) Copyright 2021 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# 
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
#

.EXPORT_ALL_VARIABLES:

#tools
VIVADO  = $(XILINX_VIVADO)/bin/vivado
DTC     = $(XILINX_VITIS)/bin/dtc
BOOTGEN = $(XILINX_VITIS)/bin/bootgen
XSCT    = $(XILINX_VITIS)/bin/xsct

#platform specific
PLATFORM = xilinx_vck190_base_dfx
CPU_ARCH = a72
BOARD    = versal-vck190-reva-x-ebm-01-reva
CORE     = psv_cortexa72_0

#versioning
VERSION          ?= 202210_1
VER              ?= 202210.1

#common
TOP_DIR         ?= $(shell readlink -f .)

#hw related
XSA_DIR         ?= $(TOP_DIR)/hw/build
XSA             ?= $(XSA_DIR)/hw.xsa
RP_XSA          ?= $(XSA_DIR)/rp/rp.xsa
STATIC_XSA      ?= $(XSA_DIR)/static.xsa
HW_EMU_XSA      ?= $(XSA_DIR)/hw_emu/hw_emu.xsa
PRE_SYNTH       ?= FALSE

#sw related
SW_DIR           = $(TOP_DIR)/sw/build
BOOT_DIR         = $(SW_DIR)/platform/boot
IMAGE_DIR        = $(SW_DIR)/platform/image
DTB_FILE         = $(BOOT_DIR)/system.dtb
BOOT_IMAGE       = $(BOOT_DIR)/BOOT.BIN
SW_FILES         = $(IMAGE_DIR)/boot.scr $(BOOT_DIR)/u-boot.elf $(BOOT_DIR)/bl31.elf
BOOT_FILES       = u-boot.elf bl31.elf
SYSROOT          = $(TOP_DIR)/platform_repo/sysroot

#platform related
PLATFORM_NAME    = $(PLATFORM)_$(VERSION)
PLATFORM_SW_SRC  = $(TOP_DIR)/platform
PLATFORM_DIR      = $(TOP_DIR)/platform_repo

#flow related
PETALINUX_BUILD ?= FALSE
PREBUILT_LINUX_PATH ?= /opt/xilinx/platform/xilinx-versal-common-v2022.1
ifneq ($(wildcard $(TOP_DIR)/xilinx-versal-common-v2022.1),)
PREBUILT_LINUX_PATH ?= $(TOP_DIR)/xilinx-versal-common-v2022.1
endif
# Getting Absolute paths
ifneq ("$(wildcard $(STATIC_XSA))","")
  STATIC_XSA_ABS ?= $(realpath $(STATIC_XSA))
  override STATIC_XSA := $(realpath $(STATIC_XSA_ABS))
endif
ifneq ("$(wildcard $(RP_XSA))","")
  RP_XSA_ABS ?= $(realpath $(RP_XSA))
  override RP_XSA := $(realpath $(RP_XSA_ABS))
endif
ifneq ("$(wildcard $(HW_EMU_XSA_ABS))","")
  HW_EMU_XSA_ABS ?= $(realpath $(HW_EMU_XSA))
  override HW_EMU_XSA := $(realpath $(HW_EMU_XSA_ABS))
endif
ifneq ("$(wildcard $(PREBUILT_LINUX_PATH_ABS))","")
  PREBUILT_LINUX_PATH_ABS ?= $(realpath $(PREBUILT_LINUX_PATH))
  override PREBUILT_LINUX_PATH := $(realpath $(PREBUILT_LINUX_PATH_ABS))
endif

#common targets
check-vitis:
ifeq ($(XILINX_VITIS),)
	$(error ERROR: 'XILINX_VITIS' variable not set, please set correctly and rerun)
endif

check-prebuilt:
ifeq (,$(wildcard $(PREBUILT_LINUX_PATH)))
	$(info )
	$(info PREBUILT common images cannot be found at $(PREBUILT_LINUX_PATH))
	$(info If PREBUILT common images are present in another directory, Please specify the path to images as follows :)
	$(info make all PREBUILT_LINUX_PATH=/path/to/boot_files/dir)
	$(info else)
	$(info Please download PREBUILT common images from https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-platforms.html and extract them to /opt/xilinx/platform)
	$(error )
else
	$(info Found Platform Images at $(PREBUILT_LINUX_PATH))
endif
ifeq ($(PREBUILT_LINUX_PATH),)
	$(error ERROR: 'PREBUILT_LINUX_PATH' is not accesible, please set this flag to path containing common software)
endif

check-petalinux:
ifeq ($(PETALINUX),)
	$(error ERROR: 'PETALINUX' variable not set, Please install PetaLinux or use pre-built software images to build the platform. Please refer to build instructions in readme for more details.)
endif
