#
# This file is the ai-camera recipe.
#

SUMMARY = "Simple ai-camera application"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://ai-camera.sh"

S = "${WORKDIR}"

do_install() {
	     install -d ${D}${bindir}
	     install -m 0755 ai-camera.sh ${D}${bindir}/ai-camera
}

RDEPENDS_${PN}_append += "bash"
