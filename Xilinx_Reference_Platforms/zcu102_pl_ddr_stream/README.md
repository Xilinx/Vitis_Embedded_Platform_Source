# Vitis PL DDR and Streaming Test Platform for the ZCU102 Board

This platform comes with PetaLinux and enables 512 MiB of PL DDR. It also contains
a free-running binary counter exposed to the platform as an AXIS interface through
a 1 k-sample AXI stream FIFO (2 KiB). It is useful for exercising various edge
platform capabilities and topologies.

It also includes a graphical interface for exercising various ML algorithms with
rudimentary GUIs.

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

Note that by default this Makefile will install the platform to **../../repo/<Platform Name>**.
To change that location edit the `REPO_DIR=...` line in the Makefile.

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

