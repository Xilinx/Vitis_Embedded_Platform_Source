CWD = $(shell readlink -f .)
TOP_DIR = $(CWD)
include $(CWD)/platform.mk

############################## Help Section ##############################
.PHONY: help

help::
	@echo 'Makefile Usage:'
	@echo ''
	@echo '  All the make commands install platform to "platform_repo/$(PLATFORM_NAME)/export/$(PLATFORM_NAME)"'
	@echo ''
	@echo '  make all'
	@echo '      Command used to generate platform with petalinux. Source petalinux before running this command.'
	@echo '      This command builds all software components.'
	@echo ''
	@echo '  make all PREBUILT_LINUX_PATH=<path/to/common_sw/dir>'
	@echo '      Command used to generate platform with pre-built software components.'
	@echo ''
	@echo '  make all PRE_SYNTH=FALSE PREBUILT_LINUX_PATH=<path/to/common_sw/dir>'
	@echo '      Command used to generate platform with post-impl xsa and pre-built software components.'
	@echo '      By default, PRE_SYNTH=TRUE.'
	@echo ''
	@echo '  make all PRE_SYNTH=FALSE'
	@echo '      Command used to generate platform with post-impl xsa using petalinux. Source petalinux before running this command.'
	@echo '      By default, PRE_SYNTH=TRUE.'
	@echo ''
	@echo '  make linux XSA=/home/user/$(PLATFORM_NAME)/vivado/build/$(PLATFORM_NAME).xsa'
	@echo '  make platform'
	@echo '      Run these commands when XSA is already built in some other folder and no modifications are needed to it.'
	@echo '      XSA should point to $(PLATFORM_NAME).xsa file.'
	@echo ''
	@echo '  make clean '
	@echo '      Command to remove all the generated files.'
	@echo ''

.PHONY: all xsa linux petalinux_sysroot platform pre-built clean

xsa: $(XSA)

$(XSA):
	$(MAKE) -C hw all

linux: xsa
	$(MAKE) -C sw all

petalinux_sysroot:
	$(MAKE) -C sw/petalinux sysroot
	@if [ -d $(SYSROOT) ]; then cp -rf $(SYSROOT) $(OUTPUT_PATH)/; fi

$(SW_COMP_FILES):
ifeq ($(COMMON_RFS_KRNL_SYSROOT), TRUE)
	$(MAKE) -C sw/prebuilt_linux sw_comp
else
	$(MAKE) -C sw/petalinux sw_comp
endif

platform: $(XSA) $(SW_COMP_FILES)
	$(eval XSA_DIR = $(dir $(XSA)))
	$(XSCT) -nodisp -sdx $(PLATFORM_SW_SRC)/${PLATFORM}_pfm.tcl ${PLATFORM_NAME} ${XSA_DIR} $(SW_COMP_DIR) ${OUTPUT_PATH}
	@if [ -d $(SW_COMP_DIR)/platform/filesystem ]; then cp -rf ${SW_COMP_DIR}/platform/filesystem $(OUTPUT_PATH)/${PLATFORM_NAME}/export/${PLATFORM_NAME}/sw/${PLATFORM_NAME}/xrt/; fi

pre-built:
	@if [ -f $(SW_COMP_DIR)/platform/BOOT.BIN ]; then mkdir -p $(OUTPUT_PATH)/${PLATFORM_NAME}/export/${PLATFORM_NAME}/pre-built/ && cp -rf $(SW_COMP_DIR)/platform/BOOT.BIN $(OUTPUT_PATH)/${PLATFORM_NAME}/export/${PLATFORM_NAME}/pre-built/; fi

clean:
	$(MAKE) -C hw clean
	$(MAKE) -C sw clean
	${RM} -r $(OUTPUT_PATH)

all: xsa linux platform pre-built
	@echo 'Platform build complete'
