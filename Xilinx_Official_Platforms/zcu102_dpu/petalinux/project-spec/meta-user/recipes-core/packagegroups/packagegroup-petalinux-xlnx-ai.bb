DESCRIPTION = "Xlnx AI Packages"

inherit packagegroup

XLNX_AI_LIBS = " \
	glog \
	gtest \
	gtest-staticdev \
	json-c \
	json-c-dev \
	libeigen-dev \
	libcanberra-gtk3 \
	libdrm \
	libdrm-kms \
	libdrm-tests \
	libx11-locale \
	opencv \
	opencv-dev \
	protobuf \
	protobuf-dev \
	protobuf-c \
	python3-pip \
"

XLNX_AI_UTILS = " \
	apt \
	auto-resize \
	cmake \
	dpkg \
	i2c-tools \
	packagegroup-petalinux-v4lutils \
	xrandr \
"

XLNX_AI_APP = " \
	dhcp-client \
	glmark2 \
	xauth \
	nfs-utils \
	openssh-sftp-server \
"

XLNX_AI_PACKAGES = " \
	ai-camera \
	base-files \
	dpuclk \
	resolvconf \
	screen-flicker \
	tzdata \
	ntp \
	packagegroup-petalinux-weston \
	xfce4-terminal \
	${XLNX_AI_LIBS} \
	${XLNX_AI_UTILS} \
	${XLNX_AI_APP} \
"

RDEPENDS_${PN} = "${XLNX_AI_PACKAGES}"
