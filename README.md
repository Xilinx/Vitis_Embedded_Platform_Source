# Vitis Minimal HW Test Platform for the ZCU104 Board

This platform comes with Qt, OpenCV, and gstreamer. It does not support DFX, the VCU,
or any external interfaces. It is intended for exercising the DPU and other PL-only
kernels for testing Vitis 2019.2.

# Building the Platform

**Last Tested Vitis Release: 2019.2**

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

Note that by default this Makefile will install the platform to **../../repo/<Platform Name>**.
To change that location edit the `REPO_DIR=...` line in the make.inc.

# Installing the Yocto SDK

To build non-trivial Linux software for this platform we bundle a Yocto SDK "sysroot"
package. It is by default installed to \$(REPO_DIR)/\$(PLATFORM)/sysroot. Before use it
needs to be extracted.

```
cd $REPO_DIR/$PLATFORM/sysroot
./sdk.sh
```

Choose your install directory. It is strongly recommended to use the same sysroot
directory you're currently in.

To cross-compile against this platform from the command line, source the
`environment-setup-aarch64-xilinx-linux` script to set up your environment (cross
compiler, build tools, libraries, etc).

