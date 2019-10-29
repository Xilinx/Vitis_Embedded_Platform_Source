# Vitis Base Platform for the zcu102 Board

This platform comes with PetaLinux and includes OpenCV. It is useful
as a base platform for exercising Vitis capabilities and topologies on the zcu102 board.

# Building the Platform

**Last Tested Vivado Release: 2019.2**

The platform build process is entirely scripted. Note that as this platform
build process involves cross-compiling Linux, build of the platform is supported
on Linux environments **only** (although it is possible to build inside a VM or
Docker container).

Also note that the default PetaLinux configuration uses local scratchpad areas. This
will *not* work if you are building on a networked file system; Yocto will error out.
Update PetaLinux to change the build area to a locally-mounted hard drive (most
Xilinx internal network servers have a /scratch or /tmp area for this purpose).

After cloning the platform source, and with both Vivado and PetaLinux set up, run
`make` from the top-level platform directory.

Note that by default this Makefile will install the platform to "platform_repo/zcu102_base/export/zcu102_base/"

# Installing the Yocto SDK

A bundled Yocto SDK "sysroot" is not available with this package by default. To build
non-trivial Linux software for this platform sysroot need to be built and installed.
This can be done with command "make peta_sysroot"
It is installed to "platform_repo/sysroot" once the build completes.

To cross-compile against this platform from the command line, source the
`environment-setup-aarch64-xilinx-linux` script to set up your environment (cross
compiler, build tools, libraries, etc).

# Build instructions:
#Build platform from scratch:
	make all

#Build a platform without modifying hardware?
	make petalinux_proj XSA_DIR=<xsa dir path>
	make pfm <xsa dir path>

	example:
		make petalinux_proj XSA_DIR=/home/user/zcu102_base/vivado
		make pfm /home/user/zcu102_base/vivado
