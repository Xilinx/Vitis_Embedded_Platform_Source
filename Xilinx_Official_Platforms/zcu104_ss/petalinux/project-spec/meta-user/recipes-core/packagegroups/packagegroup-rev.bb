DESCRIPTION = "reVISION related Packages"

inherit packagegroup

APP_PACKAGES = " \
	gst-plugins-xlnx \
	gst-sdx \
	trd-files \
	"

RDEPENDS_${PN}_append += " \
	packagegroup-core-tools-debug \
	packagegroup-petalinux-display-debug \
	packagegroup-petalinux-gstreamer \
	packagegroup-petalinux-opencv \
	packagegroup-petalinux-v4lutils \
	packagegroup-petalinux-x11 \
	ffmpeg \
	file \
	ldd \
	openblas \
	${APP_PACKAGES} \
	"
