SRC_URI += "file://bsp.cfg"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
	file://0001-dt-bindings-display-xlnx-Add-support-for-v2.2-of-IP.patch	\
	file://0002-staging-xlnx_ctrl_driver-Add-support-for-IP-v2.2.patch	\
"
