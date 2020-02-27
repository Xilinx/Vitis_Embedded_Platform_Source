#
# This file is the screen-flicker recipe.
#

SUMMARY = "Simple screen-flicker application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://screen-flicker \
	"

S = "${WORKDIR}"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit update-rc.d
INITSCRIPT_NAME = "screen-flicker"
INITSCRIPT_PARAMS = "start 99 S ."
do_install() {
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${S}/screen-flicker ${D}${sysconfdir}/init.d/screen-flicker
}
FILES_${PN} += "${sysconfdir}/*"
