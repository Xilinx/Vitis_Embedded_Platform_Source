.PHONY: all linux clean

all linux:
ifeq ($(PREBUILT_LINUX_PATH),)
	$(info )
	$(info INFO: Since 'PREBUILT_LINUX_PATH' is not set, PetaLinux will be used to build software images.)
	$(info You can skip PetaLinux building step by downloading common software image from www.xilinx.com/download and set PREBUILT_LINUX_PATH to point to software image.)
	$(info )
	$(MAKE) -C petalinux all
else
	$(MAKE) -C prebuilt_linux all
endif

clean:
	@if [ -d prebuilt_linux/build ]; then  \
		$(MAKE) -C prebuilt_linux clean; \
	fi
	@if [ -d petalinux/build ]; then  \
		$(MAKE) -C petalinux clean; \
	fi
