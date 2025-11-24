#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

include platform.mk

############################## Help Section ###############################
.PHONY: help

help::
	@echo 'Makefile Usage:'
	@echo ''
	@echo '  All the make commands install platform to "platform_repo/$(PLATFORM_NAME)/export/$(PLATFORM_NAME)"'
	@echo ''
	@echo '  make all'
	@echo '      Command used to generate platform with pre-built software components.'
	@echo ''
	@echo '  make all PRE_SYNTH=TRUE'
	@echo '      Command used to generate platform with post-impl xsa and pre-built software components.'
	@echo '      By default, PRE_SYNTH=FALSE.'
	@echo ''
	@echo '  make platform'
	@echo '      Run these commands when XSA is already built in some other folder and no modifications are needed to it.'
	@echo '      XSA should point to $(PLATFORM_NAME).xsa file.'
	@echo ''
	@echo '  make clean '
	@echo '      Command to remove all the generated files.'
	@echo ''

.PHONY: all xsa linux platform clean

xsa: $(XSA)

$(XSA):
	$(MAKE) -C hw all


all platform: $(XSA)

	@echo "INFO: Creating Platform $(PLATFORM_NAME)"
	vitis -s $(PLATFORM_SW_SRC)/generate_platform.py --platform_name $(PLATFORM_NAME) --xsa_path $(XSA)  --emu_xsa_path $(HW_EMU_XSA) --platform_out $(PLATFORM_DIR) 

	@echo "INFO: Checking created platforms:" && find . -name "*.xpfm"
	echo "Platform created:" && \
	find . -name "*.xpfm"


clean:
	$(MAKE) -C hw clean
	${RM} -r $(PLATFORM_DIR)

