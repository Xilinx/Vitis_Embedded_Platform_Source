PLATFORM ?= zc706_base
CWD=$(shell pwd)
XSA_DIR ?= $(CWD)/vivado
XSCT = $(XILINX_VITIS)/bin/xsct

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
pfm:
	$(XSCT) -sdx scripts/${PLATFORM}_pfm.tcl ${PLATFORM}

cleanall:
	${RM} -r platform_repo
	$(MAKE) -C vivado clean PLATFORM=$(PLATFORM)
	$(MAKE) -C petalinux ultraclean PLATFORM=$(PLATFORM)
