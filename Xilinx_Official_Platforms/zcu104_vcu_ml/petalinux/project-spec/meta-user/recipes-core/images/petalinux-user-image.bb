DESCRIPTION = "PETALINUX image definition for Xilinx boards"
LICENSE = "MIT"

require recipes-core/images/petalinux-image-common.inc 

inherit extrausers 
COMMON_FEATURES = "\
		ssh-server-dropbear \
		hwcodecs \
		"
IMAGE_LINGUAS = " "

IMAGE_INSTALL = "\
		kernel-modules \
		mtd-utils \
		canutils \
		openssh-sftp-server \
		pciutils \
		run-postinsts \
		opencv \
		udev-extraconf \
		gstreamer1.0-plugins-bad \
		gstreamer1.0-plugins-base \
		gstreamer1.0-plugins-good \
		kernel-module-hdmi \
		packagegroup-core-boot \
		packagegroup-core-ssh-dropbear \
		tcf-agent \
		gstreamer1.0 \
		gstreamer1.0-omx \
		bridge-utils \
		hellopm \
		libdrm \
		libdrm-tests \
		libdrm-kms \
		packagegroup-petalinux-opencv \
		ev-vcu-plt \
		gst-sdx \
		gstreamer-vcu-examples \
		xrt-dev \
		xrt \
		zocl \
		mnt-sd \
		opencl-headers-dev \
		opencl-clhpp-dev \
		opencl-clhpp-dev \
		opencl-headers-dev \
		rtsp-app \
		xrt \
		xrt-dev \
		zocl \
		"
EXTRA_USERS_PARAMS = "usermod -P root root;"
