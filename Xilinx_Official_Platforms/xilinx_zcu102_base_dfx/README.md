# Vitis Base dfx Platform for the zcu102 Board

This platform comes with PetaLinux and includes OpenCV. It is useful
as a Partial reconfiguration based base platform for exercising Vitis capabilities
and topologies on the zcu102 board.

## Build the Platform

**Last Tested Vivado Release: 2020.2**

The platform build process is entirely scripted. Note that as this platform
build process involves cross-compiling Linux, build of the platform is supported
on Linux environments **only** (although it is possible to build inside a VM or
Docker container).

Also note that the default PetaLinux configuration uses local scratchpad areas. This
will *not* work if you are building on a networked file system; Yocto will error out.
Update PetaLinux to change the build area to a locally-mounted hard drive (most
Xilinx internal network servers have a /scratch or /tmp area for this purpose).

After cloning the platform source, and with both Vivado and PetaLinux set up, run
`make` command with appropriate flags from the top-level platform directory.

By default this Makefile will install the platform to "platform_repo/xilinx_zcu102_base_dfx_202020_1/export/xilinx_zcu102_base_dfx_202020_1/"

## Platform Specification

### General Information

| Type              | Value                           |
| ----------------- | ---------------------------     |
| Release Version   | xilinx_zcu102_base_dfx_202020_1 |
| Vitis version     | 2020.2                          |
| PetaLinux version | 2020.2                          |
| XRT Tag version   | [202020.2.8.0_Petalinux](https://github.com/Xilinx/XRT/releases/tag/202020.2.8.0_PetaLinux)              |
| Target board      | ZCU102                          |

### Interfaces

| Interface | Region | Details            |
| --------- | ------ | ------------------ |
| UART      | PS     |                    |
| GEM       | PS     |                    |
| USB       | PS     | USB driver enabled |
| SDIO      | PS     |                    |

### Hardware Configurations

| Configuration                 | Values                                                | Details                               |
| ----------------------------- | ----------------------------------------------------- | ------------------------------------|
| PS DDR Size                   | 4GB                                                   |                                     |
| Clocks for Kernels            | 150MHz, 300MHz, 75MHz, 100MHz, 200MHz, 400MHz, 600MHz | Clocks are synchronous to each other|
| PS DDR Interfaces for Kernels | HP0, HP1, HP2, HP3                                    | They share the same PS DDR.         |
| Interrupts                    | 32 Interrupts are enabled from PL Kernel to PS        |                                     |

### Software Configurations

The software configurations are based on [ZCU102 BSP](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html). Here is the list of additional configurations.

| Configuration                    | Values                                                       | Details |
| -------------------------------- | ------------------------------------------------------------ | ------- |
| Additional Kernel Configurations | CONFIG_CONSOLE_LOGLEVEL_DEFAULT=1                            |         |
| Additional RootFS Components     | DNF<br />e2fsprogs-resize2fs<br />parted<br />libmali-xlnx: disabled<br />xrt, xrt-dev and zocl<br />opencl-clhpp<br />opencl-headers<br />libdrm, libdrm-tests and libdrm-kms<br />packagegroup-petalinux-audio<br />packagegroup-petalinux-gstreamer<br />packagegroup-petalinux-matchbox<br />packagegroup-petalinux-opencv<br />packagegroup-petalinux-v4lutils<br />packagegroup-petalinux-vitisai<br />packagegroup-petalinux-x11<br />imagefeature-package-management<br />auto-login |         |
| Device Tree Modifications        | Add zocl node for XRT<br />Disable default dtg generated axi intc PL node and add the custom node instead |         |

# Notes

Use the V++ -p option to generate the sd_card.img file that consists rootfs.ext4 provided by petalinux along with the Image,BOOT.BIN and system.dtb from platform, v++ generated xclbin and host.exe files.

Once the Vitis platform is ready, some example applications to build with these platforms can be found here:
https://github.com/Xilinx/Vitis_Accel_Examples
