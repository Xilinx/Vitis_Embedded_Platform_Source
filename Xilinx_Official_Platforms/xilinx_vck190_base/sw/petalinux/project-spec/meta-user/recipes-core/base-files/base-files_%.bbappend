FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
dirs755 += "/media/card"

do_install_append () {
	echo "/dev/mmcblk0p1 /media/card auto defaults,sync  0  0" >> ${D}${sysconfdir}/fstab
	echo "alias ls='ls --color=auto'" >> ${D}${sysconfdir}/profile
	echo "alias ll='ls --color=auto -l'" >> ${D}${sysconfdir}/profile
	echo "alias la='ls --color=auto -la'" >> ${D}${sysconfdir}/profile
	echo "export PATH=/media/card:/media/card/bin:\$PATH" >> ${D}${sysconfdir}/profile
}
