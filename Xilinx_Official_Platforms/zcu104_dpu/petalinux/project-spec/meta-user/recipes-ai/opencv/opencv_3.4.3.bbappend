#

PACKAGECONFIG_remove = " gstreamer"
PACKAGECONFIG_append = " libav ffmpeg"
PACKAGECONFIG[ffmpeg] = "-DWITH_FFMPEG=ON,-DWITH_FFMPEG=OFF,ffmpeg,"

do_install_append() {
	rm ${D}/usr/share/OpenCV/haarcascades -rf
	rm ${D}/usr/share/OpenCV/lbpcascades -rf
}

