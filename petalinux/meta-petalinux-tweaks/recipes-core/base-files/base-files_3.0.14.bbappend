SUMMARY = "Replace default .bashrc with a better one"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://my.dot.bashrc"
SRC_URI += "file://my.dot.profile"
SRC_URI += "file://my.fstab"

do_install_append() {
	install -m 0755 ${WORKDIR}/my.dot.bashrc ${D}${sysconfdir}/skel/.bashrc
	install -m 0755 ${WORKDIR}/my.dot.profile ${D}${sysconfdir}/skel/.profile
	install -m -7500 ${WORKDIR}/my.dot.profile ${D}/home/root/.profile
        install -m 0755 ${WORKDIR}/my.fstab ${D}${sysconfdir}/fstab
        install -d ${D}/media/card
}

FILES_${PN} += " /media/card"
