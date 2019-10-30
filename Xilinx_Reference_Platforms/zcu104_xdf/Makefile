PLATFORM=zcu104_xdf

# Output Directory is defined in make.inc
include make.inc

HW_PLATFORM=$(PLATFORM).xsa

.phony: all

all: $(PLATFORM)

$(PLATFORM): ./dsa/$(HW_PLATFORM) ./scripts/pfm.tcl ./sw_platform/image/image.ub
	xsct -sdx ./scripts/pfm.tcl
ifeq (, $(wildcard $(REPO_DIR)))
	mkdir -p $(REPO_DIR)
else
	${RM} -r $(REPO_DIR)/$(PLATFORM)
endif
	#mkdir -p sw_platform/prebuilt
	#sds++ -sds-pf output/${PLATFORM}/export/${PLATFORM} -sds-sys-config linux \
	#	-c generics/sw/hello.cpp -o hello.o
	#sds++ -sds-pf output/${PLATFORM}/export/${PLATFORM} -verbose \
	#	-sds-sys-config linux hello.o -o hello.elf
	#cp _sds/.llvm/apsys_0.xml sw_platform/prebuilt
	#cp _sds/p0/vpl/system.bit sw_platform/prebuilt/bitstream.bit
	#cp _sds/.llvm/partitions.xml sw_platform/prebuilt
	#cp _sds/swstubs/portinfo.c sw_platform/prebuilt
	#cp _sds/swstubs/portinfo.h sw_platform/prebuilt
	#cp _sds/p0/vpl/system.hdf sw_platform/prebuilt/${PLATFORM}.hdf
	#${RM} -r _sds
	#${RM} hello.*
	#${RM} -r output
	#${RM} -r sd_card
	#xsct -sdx ./scripts/pfm_prebuilt.tcl
	mv output/$(PLATFORM)/export/$(PLATFORM) $(REPO_DIR)/$(PLATFORM)
	mkdir -p $(REPO_DIR)/$(PLATFORM)/sysroot
	cp petalinux/images/linux/sdk.sh $(REPO_DIR)/$(PLATFORM)/sysroot

./dsa/$(HW_PLATFORM) : ./scripts/gen_hw_platform.tcl ./vivado/$(PLATFORM)/$(PLATFORM).xpr
	vivado -nojournal -nolog -mode batch -source ./scripts/gen_hw_platform.tcl \
		vivado/$(PLATFORM)/$(PLATFORM).xpr

./vivado/$(PLATFORM)/$(PLATFORM).xpr: ./vivado/project.tcl
	vivado -nojournal -nolog -mode batch -source ./vivado/project.tcl

./sw_platform/image/image.ub:
	$(MAKE) -C petalinux refresh-hw
	$(MAKE) -C petalinux
	$(MAKE) -C petalinux sdx
	$(MAKE) -C petalinux sdk

clean:
	${RM} -r output

ultraclean: clean
	${RM} -r dsa
	${RM} -r vivado/$(PLATFORM)
	${RM} -r vivado/.Xil
	${RM} -r sw_platform
	$(MAKE) -C petalinux ultraclean
