PLATFORM=zcu102_pl_ddr_stream

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
	mv output/$(PLATFORM)/export/$(PLATFORM) $(REPO_DIR)/$(PLATFORM)
	mkdir -p $(REPO_DIR)/$(PLATFORM)/sysroot
	cp petalinux/images/linux/sdk.sh $(REPO_DIR)/$(PLATFORM)/sysroot
	mkdir -p $(REPO_DIR)/pack
	tar -pcvf $(REPO_DIR)/pack/$(PLATFORM).tar.gz -I pigz -C $(REPO_DIR) $(PLATFORM)

./dsa/$(HW_PLATFORM) : ./scripts/gen_hw_platform.tcl ./vivado/$(PLATFORM)/$(PLATFORM).xpr
	vivado -nojournal -nolog -mode batch -source ./scripts/gen_hw_platform.tcl \
		vivado/$(PLATFORM)/$(PLATFORM).xpr

./vivado/$(PLATFORM)/$(PLATFORM).xpr: ./vivado/project.tcl
	vivado -nojournal -nolog -mode batch -source ./vivado/project.tcl

./sw_platform/image/image.ub:
	$(MAKE) -C petalinux refresh-hw
	$(MAKE) -C petalinux linux
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
	${RM} -r .Xil
