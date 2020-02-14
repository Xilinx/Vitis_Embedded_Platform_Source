#
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

RDEPENDS_${PN} += "adwaita-icon-theme"

do_install_append() {
	cp ${WORKDIR}/weston.ini ${D}${sysconfdir}/xdg/weston/
}

FILES_${PN} += "${datadir}/weston/*"
