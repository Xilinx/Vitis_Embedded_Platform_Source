#
DESCRIPTION = "dpu_clk tool"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = " \
	file://dpu_clk \
"
S = "${WORKDIR}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


do_install_append () {
	install -d ${D}/usr/bin
	install -m 0755 ${WORKDIR}/dpu_clk ${D}/usr/bin/dpu_clk
}

do_package_qa () {
	echo ""
}

FILES_${PN} += "/usr/bin/"


