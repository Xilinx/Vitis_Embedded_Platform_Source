PLATFORM ?= xilinx_zcu102_base_dfx_202010_1
CWD=$(shell pwd)
XSA_DIR ?= $(CWD)/vivado
OUTPUT_PATH ?= $(CWD)/platform_repo
XSCT = $(XILINX_VITIS)/bin/xsct
export COMMON_RFS_KRNL_SYSROOT = TRUE

.phony: all

$(PLATOFORM): all
all: $(PLATFORM)

$(PLATFORM): xsa petalinux_proj pfm
	@echo 'Platform build complete'

xsa:
	$(MAKE) -C vivado PLATFORM=$(PLATFORM)

petalinux_proj:
	$(MAKE) -C petalinux all XSA_DIR=$(XSA_DIR) PLATFORM=$(PLATFORM)

peta_sysroot:
	$(MAKE) -C petalinux sysroot

ifeq ($(COMMON_RFS_KRNL_SYSROOT), TRUE)
pfm:
	$(XSCT) -nodisp -sdx scripts/${PLATFORM}_pfm.tcl ${PLATFORM} ${XSA_DIR} ${OUTPUT_PATH}
else
pfm:
	$(XSCT) -nodisp -sdx scripts/${PLATFORM}_pfm.tcl ${PLATFORM} ${XSA_DIR} ${OUTPUT_PATH}
	cp -rf platform_repo/tmp/sw_components/src/filesystem platform_repo/${PLATFORM}/export/${PLATFORM}/sw/${PLATFORM}/
endif

cleanall:
	${RM} -r platform_repo
	$(MAKE) -C vivado clean PLATFORM=$(PLATFORM)
	$(MAKE) -C petalinux ultraclean PLATFORM=$(PLATFORM)
