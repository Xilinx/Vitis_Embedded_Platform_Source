FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_${PN} += "resolvconf"

do_install_append () {
	sed -i "/PATH=\"\/usr/a\export HOME=\/home\/root" ${D}${sysconfdir}/profile

	echo "alias ls='ls --color=auto'" >> ${D}${sysconfdir}/profile
	echo "alias ll='ls --color=auto -l'" >> ${D}${sysconfdir}/profile
	echo "alias la='ls --color=auto -la'" >> ${D}${sysconfdir}/profile
	echo "/etc/init.d/avahi-daemon stop >/dev/null 2>&1" >> ${D}${sysconfdir}/profile
	echo "/etc/init.d/bluetooth stop >/dev/null 2>&1" >> ${D}${sysconfdir}/profile
	echo "/etc/init.d/ofono stop >/dev/null 2>&1" >> ${D}${sysconfdir}/profile

	if [[ "${RDEPENDS_${PN}}" =~ "resolvconf" ]]; then
		echo "resolvconf -u" >> ${D}${sysconfdir}/profile
	fi

	echo "if [ -x ${bindir}/dbus-launch ]; then" >> ${D}${sysconfdir}/profile
	echo "	if [ -z \"\$DBUS_SESSION_BUS_ADDRESS\" ]; then" >> ${D}${sysconfdir}/profile
	echo "		eval \`dbus-launch --sh-syntax --exit-with-session </dev/null\`" >> ${D}${sysconfdir}/profile
	echo "	fi" >> ${D}${sysconfdir}/profile
	echo "fi" >> ${D}${sysconfdir}/profile

	echo "export PS1=\"\[\e[32m\]\u\[\e[m\]@\[\e[31m\]\h\[\e[m\]:\[\e[31m\]\w\[\e[m\]# \"" >> ${D}${sysconfdir}/profile
}
