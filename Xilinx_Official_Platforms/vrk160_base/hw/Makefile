#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

include ../platform.mk

TCL_SOURCE=xsa_scripts/xsa.tcl

.PHONY: all xsa

## add metadata for v++ package to generate system.dtb and BOOT.BIN
metadata: $(METADATA)
	$(MAKE) -C metadata all

all xsa : $(XSA)
$(XSA): $(TCL_SOURCE)
	$(VIVADO) -mode batch -notrace -source $(TCL_SOURCE) -tclargs $(PLATFORM_NAME) $(VER) $(PRE_SYNTH) "dynamic_reload"

clean:
	$(RM) -r vivado* build .Xil *dynamic* *.log* *.xpe *.xsa 
	${RM} -r $(PLATFORM_DIR)
	$(RM) -r $(TOP_DIR)/hw/zocl.dtsi $(TOP_DIR)/hw/zocl_dtsi_extracted/boot.bin-extracted
