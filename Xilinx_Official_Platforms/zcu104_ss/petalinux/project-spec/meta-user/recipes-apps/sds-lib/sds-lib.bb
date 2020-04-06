#
# This is the sds-lib recipe
#
#

SUMMARY = "SDSoC library and headers"
SECTION = "PETALINUX/apps"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/target/aarch64-linux/include/sds_lib.h;beginline=1;endline=38;md5=7778565706fda1507f1f506ad9d9022b"

SRC_URI = "file://sds-lib.zip"

S = "${WORKDIR}/target"

# select libs/headers based on target ARCH
ARCH_DIR_zynq = "aarch32-linux"
ARCH_DIR_zynqmp = "aarch64-linux"

do_install() {
    # install headers
    install -d ${D}${includedir}
    install -m 0644 ${S}/${ARCH_DIR}/include/*.h ${D}${includedir}/

    # install libs
    install -d ${D}${libdir}
    oe_libinstall -C ${S}/${ARCH_DIR}/lib -so libsds_lib ${D}${libdir}/
    oe_libinstall -C ${S}/${ARCH_DIR}/lib -so libsds_lib_dbg ${D}${libdir}/
}

# do not split or strip libraries
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

FILES_${PN} += "${libdir}/*.so"
FILES_SOLIBSDEV = ""
