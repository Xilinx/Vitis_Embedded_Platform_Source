FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append ="\
    file://base_trd/drm-hdmi.dtsi \
    file://base_trd/pl.dtsi \
    file://base_trd/qos.dtsi \
    file://base_trd/rpu0.dtsi \
    file://base_trd/rpu1.dtsi \
    file://base_trd/vcap-csi.dtsi \
    file://base_trd/vcap-hdmi.dtsi \
    file://common/li-imx274mipi-fmc.dtsi \
    file://common/xlnk.dtsi \
    file://system-user.dtsi \
    file://zcu104/system-conf.dtsi \
"
