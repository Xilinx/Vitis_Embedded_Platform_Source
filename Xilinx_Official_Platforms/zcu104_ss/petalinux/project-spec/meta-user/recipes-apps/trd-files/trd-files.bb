#
# This is the trd-files recipe
#
#

SUMMARY = "TRD Files"
SECTION = "PETALINUX/apps"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
	file://trd-autostart.sh \
	file://run_video.sh \
	file://autostart.sh \
	file://trd-utils.sh \
	file://dropbear_rsa_host_key \
	"

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "trd-autostart"
INITSCRIPT_PARAMS = "start 99 5 ."

do_install() {
	install -d ${D}${sysconfdir}/init.d
	install -m 0755 ${S}/trd-autostart.sh ${D}${sysconfdir}/init.d/trd-autostart

	install -d ${D}/${bindir}
	install -m 0755 ${S}/run_video.sh ${D}/${bindir}/

	install -d ${D}${sysconfdir}/trd
	install -m 0755 ${S}/autostart.sh ${D}${sysconfdir}/trd/
	install -m 0755 ${S}/trd-utils.sh ${D}${sysconfdir}/trd/

	install -d ${D}${sysconfdir}/dropbear
	install -m 0644 ${S}/dropbear_rsa_host_key ${D}${sysconfdir}/dropbear

}

FILES_${PN} += " \
	${bindir}/run_video.sh \
	"

RDEPENDS_${PN}_append += "bash"
