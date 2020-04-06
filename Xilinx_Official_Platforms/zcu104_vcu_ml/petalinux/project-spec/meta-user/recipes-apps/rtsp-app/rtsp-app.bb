#
# This is the gst-plugins-xlnx recipe
#
#

SUMMARY = "gst plugins for Xilinx video source and sink"
SECTION = "PETALINUX/apps"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/src/src/rtspapp/rtsp.c;beginline=1;endline=28;md5=aa044daaefd215a1f86383df1c842edf"

DEPENDS = "libdrm v4l-utils glib-2.0 gstreamer1.0 gstreamer1.0-plugins-base"

SRC_URI = "file://rtsp-app.zip"

S = "${WORKDIR}/src"

inherit pkgconfig cmake

FILES_${PN} += " \
        ${sbindir}/ \
        "
