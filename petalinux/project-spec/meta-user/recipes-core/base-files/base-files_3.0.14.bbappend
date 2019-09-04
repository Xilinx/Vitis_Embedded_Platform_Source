SUMMARY = "Install platform name information"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://xocl.txt"

do_install_append() {
	install -m 0755 ${WORKDIR}/xocl.txt ${D}${sysconfdir}/xocl.txt
}
