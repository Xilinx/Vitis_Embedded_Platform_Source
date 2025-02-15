#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2024 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************


SHELL := /bin/bash
VER_MAIN ?= 2024
VER_MIN ?= 2
VERSION1 ?= $(VER_MAIN).$(VER_MIN)
XSA ?= ../../../hw/build/hw.xsa
SDT_OUT ?= sdt_out
USER_DTSI ?= ../user_dts/system-user.dtsi 

all: get_sources gen_sdt gen_dtb

get_sources:
	if [ ! -d "./lopper" ];then \
		git clone https://github.com/devicetree-org/lopper; \
		cd lopper && git checkout v0.$(VER_MAIN).x; \
	fi


gen_sdt:
	$(RM) -rf $(SDT_OUT)
	$(info "DTB generation started using stdgen+lopper")
	$(XSCT) -eval "sdtgen set_dt_param -dir $(SDT_OUT) -xsa $(XSA) -board_dts versal-vck190-rev1.1 -zocl enable -include_dts $(USER_DTSI); sdtgen generate_sdt"
 
gen_dtb:
	$(RM) -rf system.dtb
	source lopper_settings.sh; \
	export LOPPER_DTC_FLAGS="-b 0 -@"; \
	lopper -f --enhanced -O . -i ./lopper/lopper/lops/lop-a72-imux.dts $(SDT_OUT)/system-top.dts system.dtb -- gen_domain_dts psv_cortexa72_0 linux_dt

clean:
	$(RM) -r *.dtb
	$(RM) -r  *.pp
	$(RM) -r sdt_out
	$(RM) -r $(SDT_OUT)
	$(RM) -r lopper
