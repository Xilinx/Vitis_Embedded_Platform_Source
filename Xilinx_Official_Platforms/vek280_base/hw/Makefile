#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

include ../platform.mk

TCL_SOURCE=xsa_scripts/xsa.tcl

.PHONY: all xsa

all xsa : $(XSA)

$(XSA): $(TCL_SOURCE)
	$(VIVADO) -mode batch -notrace -source $(TCL_SOURCE) -tclargs $(PLATFORM_NAME) $(VER) $(PRE_SYNTH)

clean:
	$(RM) -r vivado* build .Xil *dynamic* *.log* *.xpe 
	$(RM) -r $(TOP_DIR)/hw/zocl.dtsi $(TOP_DIR)/hw/zocl_dtsi_extracted/boot.bin-extracted
