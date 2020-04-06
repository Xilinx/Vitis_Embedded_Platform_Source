DESCRIPTION = "TRD related Packages"

inherit packagegroup

APP_PACKAGES = " \
	gst-plugins-xlnx \
	gst-sdx \
	perfapm-client \
	trd-files \
	video-qt2 \
	video-qt2-staticdev \
	"

RDEPENDS_${PN}_append += " \
	packagegroup-core-tools-debug \
	packagegroup-petalinux-display-debug \
	packagegroup-petalinux-gstreamer \
	packagegroup-petalinux-openamp \
	packagegroup-petalinux-opencv \
	packagegroup-petalinux-qt \
	packagegroup-petalinux-v4lutils \
	packagegroup-petalinux-x11 \
	ffmpeg \
	file \
	ldd \
	${APP_PACKAGES} \
	"
