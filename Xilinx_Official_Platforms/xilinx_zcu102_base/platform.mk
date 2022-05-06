# Copyright 2021 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.EXPORT_ALL_VARIABLES:

#tools
VIVADO  = $(XILINX_VIVADO)/bin/vivado
DTC     = $(XILINX_VITIS)/bin/dtc
BOOTGEN = $(XILINX_VITIS)/bin/bootgen
XSCT    = $(XILINX_VITIS)/bin/xsct

#platform specific
PLATFORM = xilinx_zcu102_base
CPU_ARCH = a53
BOARD    = zcu102-rev1.0
CORE     = psu_cortexa53_0

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
PRE_SYNTH       ?= TRUE

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
PREBUILT_LINUX_PATH ?= /opt/xilinx/platform/xilinx-zynqmp-common-v2022.1
ifneq ($(wildcard $(TOP_DIR)/xilinx-zynqmp-common-v2022.1),)
PREBUILT_LINUX_PATH ?= $(TOP_DIR)/xilinx-zynqmp-common-v2022.1
endif
# Getting Absolute paths
ifneq ("$(wildcard $(XSA))","")
	XSA_ABS ?= $(realpath $(XSA))
	override XSA := $(realpath $(XSA_ABS))
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
