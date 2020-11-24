export BOARD = versal-vck190-reva-x-ebm-01-reva
export CORE = psv_cortexa72_0
CWD = $(shell readlink -f .)
BUILD_DIR = $(CWD)/build

ifeq ($(COMMON_RFS_KRNL_SYSROOT), TRUE)
all:
		rm -rf $(BUILD_DIR)
		cp -rf prebuilt_linux $(BUILD_DIR)
		$(MAKE) -C $(BUILD_DIR) all 
else
all: 
		rm -rf $(BUILD_DIR)
		cp -rf petalinux $(BUILD_DIR)
		$(MAKE) -C $(BUILD_DIR) all
endif

clean:
		${RM} -r $(BUILD_DIR)
