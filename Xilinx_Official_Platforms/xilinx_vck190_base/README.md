# Vitis Base Platform for the vck190 Board

This platform comes with PetaLinux sources and includes OpenCV. It is useful as a base platform for exercising Vitis capabilities and topologies on the vck190 board.

# Building the Platform

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

Note that by default this Makefile will install the platform to "platform_repo/xilinx_vck190_base_202020_1/export/xilinx_vck190_base_202020_1/"

## Platform Specification

### General Information

| Type              | Value                       |
| ----------------- | --------------------------- |
| Release Version   | xilinx_vck190_base_202020_1 |
| Vitis version     | 2020.2                      |
| PetaLinux version | 2020.2                      |
| XRT Tag version   | [202020.2.8.0_Petalinux](https://github.com/Xilinx/XRT/releases/tag/202020.2.8.0_PetaLinux)              |
| Target board      | VCK190                      |

### Interfaces

| Interface | Region | Details            |
| --------- | ------ | ------------------ |
| UART      | PS     |                    |
| GEM       | PS     |                    |
| USB       | PS     | USB driver enabled |
| SDIO      | PS     |                    |

### Hardware Configurations

| Configuration                 | Values                                                | Details                             |
| ----------------------------- | ----------------------------------------------------- | ------------------------------------|
| CIPS DDR Size                 | 8GB                                                   |                                     |
| LPDDR Size                    |  8GB                                                  |                                     |
| Clocks for Kernels            | 150MHz, 100MHz, 300MHz, 75MHz, 200MHz, 400MHz, 600MHz | Clocks are synchronous to each other|
| SP Tags supported             | DDR, LPDDR                                            | All kernels share same DDR4 and LPDDR4 |
| Interrupts                    | 63 interrupts are enabled from PL Kernel to PS        |                                     |
| AXI Interfaces for Kernel Control | 28 M_AXI_GP AXI interfaces are enabled            |                                     |
| AI Engine                     | Enabled                                               |                                     |

### Software Configurations

The software configurations are based on [VCK190 BSP](https://www.author.xilinx.com/member/vck190-ea.html#tools). Here is the list of additional configurations.

| Configuration                    | Values                                                       | Details |
| -------------------------------- | ------------------------------------------------------------ | ------- |
| Additional Kernel Configurations | CONFIG_CONSOLE_LOGLEVEL_DEFAULT=1                            |         |
| Additional RootFS Components     | DNF<br />e2fsprogs-resize2fs<br />parted<br />xrt, xrt-dev and zocl<br />opencl-clhpp<br />opencl-headers<br />packagegroup-petalinux-opencv<br />>imagefeature-package-management<br />auto-login |         |
| Device Tree Modifications        | Add zocl node for XRT                                       |         |

# Notes

Use the V++ -p option to generate the sd_card.img file that consists rootfs.ext4 provided by petalinux along with the Image,BOOT.BIN and system.dtb from platform, v++ generated xclbin and host.exe files.

Once the Vitis platform is ready, some example applications to build with these platforms can be found here:
https://github.com/Xilinx/Vitis_Accel_Examples
