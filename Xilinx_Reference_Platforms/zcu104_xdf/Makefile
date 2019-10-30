PLATFORM=zcu104_xdf

# Output Directory is defined in make.inc
include make.inc

HW_PLATFORM=$(PLATFORM).xsa

.phony: all

all: $(PLATFORM)

$(PLATFORM): $(HW_PLATFORM) ./scripts/pfm.tcl $(REPO_DIR)/tmp/sw_components/image/image.ub
	xsct ./scripts/pfm.tcl
ifeq (, $(wildcard $(REPO_DIR)))
	mkdir -p $(REPO_DIR)
else
	${RM} -r $(REPO_DIR)/$(PLATFORM)
endif
	mv output/$(PLATFORM)/export/$(PLATFORM) $(REPO_DIR)/$(PLATFORM)
	mv petalinux/images/linux/sdk.sh $(REPO_DIR)/tmp/sw_components
	#rm output -rf


xsa: $(HW_PLATFORM)

$(HW_PLATFORM) : ./scripts/gen_hw_platform.tcl ./vivado/$(PLATFORM)/$(PLATFORM).xpr


	vivado -nojournal -nolog -mode batch -source ./scripts/gen_hw_platform.tcl \
		vivado/$(PLATFORM)/$(PLATFORM).xpr

vivado: ./vivado/$(PLATFORM)/$(PLATFORM).xpr

./vivado/$(PLATFORM)/$(PLATFORM).xpr: ./vivado/project.tcl
	vivado -nojournal -nolog -mode batch -source ./vivado/project.tcl

petalinux_proj: $(REPO_DIR)/tmp/sw_components/image/image.ub

$(REPO_DIR)/tmp/sw_components/image/image.ub:
	$(MAKE) -C petalinux refresh-hw
	$(MAKE) -C petalinux
	$(MAKE) -C petalinux sw_comp
	$(MAKE) -C petalinux sd
	$(MAKE) -C petalinux sdk

sysroot: 
	@echo  " sdk.sh is under $(REPO_DIR)/tmp/sw_components. You may execute the sdk.sh script from that directory."


clean:
	${RM} -r $(REPO_DIR)

ultraclean: clean
	${RM} -r output
	${RM} -r vivado/$(PLATFORM)
	${RM} -r vivado/.Xil
	$(MAKE) -C petalinux ultraclean
