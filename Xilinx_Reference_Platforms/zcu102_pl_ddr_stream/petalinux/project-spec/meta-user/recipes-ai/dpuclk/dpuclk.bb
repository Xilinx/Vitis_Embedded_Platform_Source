#
DESCRIPTION = "dpu_clk tool"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=fa7ffd0ad615cced5e214402246bb709"

SRC_URI = " \
	file://dpu_clk \
	file://COPYING \
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


