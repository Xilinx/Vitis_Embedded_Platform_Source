CWD = $(shell readlink -f .)
SYSTEM_USER_DTSI = $(CWD)/user_dts/system-user.dtsi
SYSTEM_CONF_DTS =  $(CWD)/user_dts/system-conf.dtsi
DTC = $(XILINX_VITIS)/bin/dtc
BOOTGEN = $(XILINX_VITIS)/bin/bootgen
TOP_DIR = $(CWD)/../../
BUILD_DIR = $(CWD)/build
PDI_FILE = $(BUILD_DIR)/$(PLATFORM_NAME).pdi
DTB_FILE = $(BUILD_DIR)/images/linux/system.dtb
BOOT_COMMON_FILES = $(BUILD_DIR)/images/linux/boot.scr $(BUILD_DIR)/images/linux/bl31.elf $(BUILD_DIR)/images/linux/u-boot.elf
AUTO_GENERATE = false

include $(TOP_DIR)/platform.mk

check-vitis:
ifeq ($(XILINX_VITIS),)
	$(error ERROR: 'XILINX_VITIS' variable not set, please set correctly and rerun)
endif

$(XSA):
	$(MAKE) -C $(TOP_DIR) xsa

$(PDI_FILE): $(XSA)
	mkdir -p $(BUILD_DIR)
	cp -f $(XSA) $(BUILD_DIR)/system.xsa
	@echo "openhw $(BUILD_DIR)/system.xsa" >> $(BUILD_DIR)/extract
	$(XSCT) $(BUILD_DIR)/extract

$(BOOT_COMMON_FILES):
	@if [ ! -d $(PREBUILT_LINUX_PATH) ]; then \
		echo "ERROR: 'PREBUILT_LINUX_PATH' is not accesible, please set this flag to path containing common software"; \
		exit 1; \
	fi

	$(info INFO: Copying Boot files from $(PREBUILT_LINUX_PATH))
	mkdir -p $(BUILD_DIR)/images/linux/
	cp -f $(PREBUILT_LINUX_PATH)/u-boot.elf $(BUILD_DIR)/images/linux/
	cp -f $(PREBUILT_LINUX_PATH)/boot.scr $(BUILD_DIR)/images/linux/
	cp -f $(PREBUILT_LINUX_PATH)/bl31.elf $(BUILD_DIR)/images/linux/

.PHONY: check-vitis all sw_comp dtb bootimage clean
sw_comp: $(SW_COMP_FILES)

$(SW_COMP_FILES): $(BOOT_COMMON_FILES) $(DTB_FILE)
	mkdir -p $(SW_COMP_DIR)
	cp -rf $(PLATFORM_SW_SRC) ${SW_COMP_DIR}
	mkdir -p ${SW_COMP_DIR}/platform/boot
	cp -f $(BUILD_DIR)/images/linux/boot.scr ${SW_COMP_DIR}/platform/image/boot.scr
	cp -f $(BUILD_DIR)/images/linux/bl31.elf ${SW_COMP_DIR}/platform/boot/bl31.elf
	cp -f $(BUILD_DIR)/images/linux/u-boot.elf ${SW_COMP_DIR}/platform/boot/u-boot.elf
	cp -f $(BUILD_DIR)/images/linux/system.dtb ${SW_COMP_DIR}/platform/boot/system.dtb

dtb: $(DTB_FILE)

$(DTB_FILE): $(XSA)
	$(info "generating sw artifacts...")
	@if [ ! -d $(BUILD_DIR) ]; then  \
			mkdir -p $(BUILD_DIR)/images/linux; \
	fi
	cp -rf $(XSCT_SCRIPTS)/dtb_generator.tcl $(BUILD_DIR)
	rm -rf $(SW_COMP_DIR)/tmp
	mkdir -p $(SW_COMP_DIR)/tmp/dt
	git clone https://github.com/Xilinx/device-tree-xlnx.git -b xlnx_rel_v2021.1 $(SW_COMP_DIR)/tmp/dt
	$(XSCT) -nodisp $(BUILD_DIR)/dtb_generator.tcl $(PLATFORM) $(SW_COMP_DIR)/tmp/dt $(XSA) $(BOARD) $(CORE) $(SW_COMP_DIR)/tmp $(AUTO_GENERATE)
	$(eval BSP_PATH = $(SW_COMP_DIR)/tmp/Workspace/$(PLATFORM)/$(CORE)/device_tree_domain/bsp/)
	$(eval BOOT_ARTIFACTS = $(SW_COMP_DIR)/tmp/Workspace/$(PLATFORM)/export/$(PLATFORM)/sw/$(PLATFORM)/boot)
	cp -rf  $(SYSTEM_CONF_DTS) $(BSP_PATH)
	cp -rf  $(SYSTEM_USER_DTSI) $(BSP_PATH)
	@if [ -f $(SYSTEM_USER_DTSI) ]; then  \
			echo  "#include \"system-user.dtsi\"" >> $(BSP_PATH)/system-top.dts; \
	fi
	cd $(BSP_PATH) && \
	cpp -Iinclude -E -P -undef -D__DTS__ -x assembler-with-cpp ./system-top.dts | $(DTC) -I dts -O dtb -o $(SW_COMP_DIR)/system.dtb - && cd -
	cp -rf $(BOOT_ARTIFACTS)/*.elf $(SW_COMP_DIR)/ 2>/dev/null || :
	rm -rf $(SW_COMP_DIR)/tmp
	cp -f $(SW_COMP_DIR)/*.dtb $(BUILD_DIR)/images/linux/ 2>/dev/null || :
	cp -f $(SW_COMP_DIR)/*.elf $(BUILD_DIR)/images/linux/ 2>/dev/null || :

all: check-vitis $(PDI_FILE) $(BOOT_COMMON_FILES) dtb sw_comp

bootimage: $(PDI_FILE) $(BOOT_COMMON_FILES) $(DTB_FILE)
	$(info "BOOT image for platforms")
	@if [ -f $(BUILD_DIR)/$(PLATFORM_NAME).pdi ]; then \
		echo "INFO: BOOT image genration started...";  \
		$(BOOTGEN) -arch versal -image $(CWD)/bootgen.bif -o $(BUILD_DIR)/images/linux/BOOT.BIN -w;  \
		if [ -d $(SW_COMP_DIR)/platform ]; then \
		  cp -rf $(BUILD_DIR)/images/linux/BOOT.BIN $(SW_COMP_DIR)/platform/;  \
		fi \
	else  \
		echo "WARNING: "$(PLATFORM_NAME).pdi" file not found in 'build' directory. Skipping BOOT image generation.";  \
	fi

clean:
	${RM} -r $(BUILD_DIR)
