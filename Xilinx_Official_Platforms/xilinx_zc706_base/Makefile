export PLATFORM = xilinx_zc706_base
export CPU_ARCH = a9

include ../common/makefiles/common.mk

############################## Help Section ##############################
.PHONY: help

help::
	@echo 'Makefile Usage:'
	@echo ''
	@echo '  All the make commands install platform to "platform_repo/$(PLATFORM_NAME)/export/$(PLATFORM_NAME)"'
	@echo ''
	@echo '  make all BOOT_FILES_PATH=<common_sw_dir>/zynq/xilinx-zynq>'
	@echo '      Command used to generate platform with pre-built Linux.'
	@echo ''
	@echo '  make all COMMON_RFS_KRNL_SYSROOT=FALSE'
	@echo '      Command used to generate platform with petalinux. Source petalinux before running this command.'
	@echo '      By default, COMMON_RFS_KRNL_SYSROOT=TRUE.'
	@echo '      This command builds all software components.'
	@echo ''
	@echo '  make all PRE_SYNTH=TRUE BOOT_FILES_PATH=<common_sw_dir>/zynq/xilinx-zynq>'
	@echo '      Command used to generate platform with pre-synth xsa and pre-built Linux.'
	@echo '      By default, PRE_SYNTH=FALSE.'
	@echo ''
	@echo '  make all PRE_SYNTH=TRUE COMMON_RFS_KRNL_SYSROOT=FALSE'
	@echo '      Command used to generate platform with pre-synth xsa using petalinux. Source petalinux before running this command.'
	@echo '      By default, PRE_SYNTH=FALSE.'
	@echo ''
	@echo '  make linux XSA_DIR=/home/user/$(PLATFORM_NAME)/vivado/build COMMON_RFS_KRNL_SYSROOT=<TRUE/FALSE>'
	@echo '  make platform'
	@echo '      Run these commands when XSA is already built in some other folder and no modifications are needed to it.'
	@echo '      XSA_DIR should point to directory containing $(PLATFORM_NAME).xsa file.'
	@echo ''
	@echo '  make clean '
	@echo '      Command to remove all the generated files.'
	@echo ''

xsa:
	$(MAKE) -C hw all

linux: xsa
	$(MAKE) -C sw all

petalinux_sysroot:
	$(MAKE) -C sw/build sysroot
	@if [ -d $(SYSROOT) ]; then cp -rf $(SYSROOT) $(OUTPUT_PATH)/; fi

.PHONY: platform
platform:
	$(XSCT) -nodisp -sdx $(PLATFORM_SW_SRC)/${PLATFORM}_pfm.tcl ${PLATFORM_NAME} ${XSA_DIR} $(SW_COMP_DIR) ${OUTPUT_PATH}
	@if [ -d $(SW_COMP_DIR)/platform/filesystem ]; then cp -rf ${SW_COMP_DIR}/platform/filesystem $(OUTPUT_PATH)/${PLATFORM_NAME}/export/${PLATFORM_NAME}/sw/${PLATFORM_NAME}/xrt/; fi

pre-built:
	@if [ -f $(SW_COMP_DIR)/platform/BOOT.BIN ]; then mkdir $(OUTPUT_PATH)/${PLATFORM_NAME}/export/${PLATFORM_NAME}/pre-built/ && cp -rf $(SW_COMP_DIR)/platform/BOOT.BIN $(OUTPUT_PATH)/${PLATFORM_NAME}/export/${PLATFORM_NAME}/pre-built/; fi

clean:
	$(MAKE) -C hw clean
	$(MAKE) -C sw clean
	${RM} -r $(OUTPUT_PATH)

all: xsa linux platform pre-built
	@echo 'Platform build complete'
