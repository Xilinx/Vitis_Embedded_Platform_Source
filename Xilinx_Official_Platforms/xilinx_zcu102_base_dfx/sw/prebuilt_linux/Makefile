CWD = $(shell readlink -f .)
SYSTEM_USER_DTSI = $(CWD)/user_dts/system-user.dtsi
SYSTEM_CONF_DTS =  $(CWD)/user_dts/system-conf.dtsi
DTC = $(XILINX_VITIS)/bin/dtc
BOOTGEN = $(XILINX_VITIS)/bin/bootgen

extract_bit:
	cp -f ${XSA} $(CWD)/system.xsa
	@echo "openhw $(CWD)/system.xsa" >> $(CWD)/extract
	$(XSCT) $(CWD)/extract

boot_common:
ifeq ($(BOOT_FILES),)
  $(error ERROR: 'BOOT_FILES_PATH' not set, please set this flag to path of boot files directory)
else
	$(info INFO: Copying Boot files from $(BOOT_FILES))
	mkdir -p images/linux/
	cp -f $(BOOT_FILES)/u-boot.elf images/linux/
	cp -f $(BOOT_FILES)/boot.scr images/linux/
	cp -f $(BOOT_FILES)/bl31.elf images/linux/
endif

device-tree:
	$(info "generating sw artifacts...")
	cp -rf $(XSCT_SCRIPTS)/dtb_generator.tcl $(CWD)
	rm -rf $(SW_COMP_DIR)/tmp
	mkdir -p $(SW_COMP_DIR)/tmp/dt
	git clone https://github.com/Xilinx/device-tree-xlnx.git $(SW_COMP_DIR)/tmp/dt
	$(XSCT) -nodisp dtb_generator.tcl $(PLATFORM) $(SW_COMP_DIR)/tmp/dt $(XSA) $(BOARD) $(CORE) $(SW_COMP_DIR)/tmp
	$(eval BSP_PATH = $(SW_COMP_DIR)/tmp/Workspace/$(PLATFORM)/$(CORE)/device_tree_domain/bsp/)
	$(eval BOOT_ARTIFACTS = $(SW_COMP_DIR)/tmp/Workspace/$(PLATFORM)/export/$(PLATFORM)/sw/$(PLATFORM)/boot)
	cp -rf  $(SYSTEM_CONF_DTS) $(BSP_PATH)
	cp -rf  $(SYSTEM_USER_DTSI) $(BSP_PATH)
	@if [ -f $(SYSTEM_USER_DTSI) ]; then  \
      echo  "#include \"system-user.dtsi\"" >> $(BSP_PATH)/system-top.dts; \
  fi
	cd $(BSP_PATH) && \
	cpp -Iinclude -E -P -x assembler-with-cpp ./system-top.dts | $(DTC) -I dts -O dtb -o $(SW_COMP_DIR)/system.dtb - && cd -
	cp -rf $(BOOT_ARTIFACTS)/*.elf $(SW_COMP_DIR)/ 2>/dev/null || :
	rm -rf $(SW_COMP_DIR)/tmp
	cp -f $(SW_COMP_DIR)/*.dtb images/linux/ 2>/dev/null || :
	cp -f $(SW_COMP_DIR)/*.elf images/linux/ 2>/dev/null || :

sw_comp:
	mkdir -p $(SW_COMP_DIR)
	cp -rf $(PLATFORM_SW_SRC) ${SW_COMP_DIR}
	cp -f images/linux/boot.scr ${SW_COMP_DIR}/platform/image/boot.scr
	cp -f images/linux/bl31.elf ${SW_COMP_DIR}/platform/boot/bl31.elf
	cp -f images/linux/u-boot.elf ${SW_COMP_DIR}/platform/boot/u-boot.elf
	cp -f images/linux/pmufw.elf ${SW_COMP_DIR}/platform/boot/pmufw.elf
	cp -f images/linux/fsbl.elf images/linux/zynqmp_fsbl.elf 2>/dev/null || :
	cp -f images/linux/zynqmp_fsbl.elf ${SW_COMP_DIR}/platform/boot/fsbl.elf
	cp -f images/linux/system.dtb ${SW_COMP_DIR}/platform/image/system.dtb

all: extract_bit boot_common device-tree sw_comp bootimage

bootimage:
	$(info "BOOT image for platforms")
	@if [ -f $(CWD)/$(PLATFORM_NAME).bit ]; then  \
		echo "INFO: BOOT image genration started...";  \
		$(BOOTGEN) -arch zynqmp -image $(CWD)/bootgen.bif -o images/linux/BOOT.BIN -w;  \
		cp -rf images/linux/BOOT.BIN ${SW_COMP_DIR}/platform/image/;  \
		cp -rf images/linux/BOOT.BIN ${SW_COMP_DIR}/platform/;  \
	else  \
		echo "WARNING: "$(PLATFORM_NAME).bit" file not found. Skipping BOOT image generation.";  \
	fi
