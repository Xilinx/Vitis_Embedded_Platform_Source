#
# This file is the dnndk recipe.
#

SUMMARY = "DNNDK Libraries"
SECTION = "libs"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://bin/dexplorer \
           file://bin/dsight \
	   file://lib/echarts.js \
           file://lib/libdputils.so \
           file://lib/libdsight.a \
           file://lib/libn2cube.so \
	   file://include/dnndk.h \
	   file://include/dputils.h \
	   file://include/n2cube.h \
	"
inherit module-base

S = "${WORKDIR}"

DEPENDS += "opencv"

TARGET_CC_ARCH += "${LDFLAGS}"

do_install() {
	     install -d ${D}/${bindir}
             install -m 0755 ${S}/bin/dexplorer ${D}/${bindir}
             install -m 0755 ${S}/bin/dsight ${D}/${bindir}

	     install -d ${D}${includedir}/dnndk
             install -m 0644 ${S}/include/dnndk.h ${D}${includedir}/dnndk/
             install -m 0644 ${S}/include/dputils.h ${D}${includedir}/dnndk/
             install -m 0644 ${S}/include/n2cube.h ${D}${includedir}/dnndk/

	     install -d ${D}${libdir}
             install -m 0655 ${S}/lib/echarts.js ${D}${libdir}
             install -m 0655 ${S}/lib/libdputils.so ${D}${libdir}
             install -m 0655 ${S}/lib/libdsight.a ${D}${libdir}
             install -m 0655 ${S}/lib/libn2cube.so ${D}${libdir}

             cd ${D}${libdir}
             #ln -s libdputils.so libdputils.so

	     install -d ${D}/usr/local/lib
             cd ${D}/usr/local/lib
             ln -s ../../lib/libn2cube.so libn2cube.so
}

INSANE_SKIP_${PN} += "ldflags"
INSANE_SKIP_${PN} += "dev-so"

FILES_SOLIBSDEV = ""

FILES_${PN} += "${libdir}/* ${includedir} /usr/local/lib"
