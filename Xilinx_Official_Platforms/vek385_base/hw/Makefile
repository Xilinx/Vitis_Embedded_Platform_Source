#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

include ../platform.mk

TCL_SOURCE=xsa_scripts/xsa.tcl

.PHONY: all xsa

all xsa : $(XSA)
#for both flat (hw.xsa) and segmented (hw_segmented.xsa) xsa
$(XSA): $(TCL_SOURCE)
	$(VIVADO) -mode batch -notrace -source $(TCL_SOURCE) -tclargs $(PLATFORM_NAME) $(VER) $(PRE_SYNTH) "dynamic_reload"

clean:
	$(RM) -r vivado* build .Xil *dynamic* *.log *.xpe *.xsa XilinxCEDStore
	${RM} -r $(PLATFORM_DIR)
