# Vitis Base Platform for the VEK280 Pre-production Board

***Version: 2023.2***

This platform comes with common hardware features on the VEK280 board like AI Engine ML, GEM, DDR and LPDDR. The platform software includes OpenCV in pre-built Common Image. It is useful as a base platform for exercising Vitis capabilities and topologies on the VEK280 board.

# Building the Platform


The platform build process is entirely scripted. Note that as this platform
build process involves cross-compiling Linux, build of the platform is supported
on Linux environments **only** (although it is possible to build inside a VM or
Docker container).

After cloning the platform source, and with Vivado set up, run `make` command
with appropriate flags from the top-level platform directory.

Note that by default this Makefile will install the platform to "platform_repo/xilinx_vek280_base_202320_1/export/xilinx_vek280_base_202320_1/"

## Platform Specification

### General Information

| Type              | Value                           |
| ----------------- | ---------------------------     |
| Release Version   | xilinx_vek280_base_202320_1 |
| Vitis version     | 2023.2                          |
| XRT Tag version   | [202320.2.16.0_PetaLinux](https://github.com/Xilinx/XRT/releases/tag/202320.2.16.0_PetaLinux)              |
| Target board      | VEK280                          |

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
| LPDDR Size                    |  12GB                                                 |                                     |
| Clocks for Kernels            | 150MHz, 100MHz, 300MHz, 75MHz, 200MHz, 400MHz, 600MHz | Clocks are synchronous to each other|
| SP Tags supported             | LPDDR                                                 | All kernels share same LPDDR4       |
| Interrupts                    | 32 interrupts are enabled from PL Kernel to PS        |                                     |
| AXI Interfaces for Kernel Control | 28 M_AXI_GP AXI interfaces are enabled            |                                     |
| AI Engine                     | Enabled                                               |                                     |

### Software Configurations

The software configurations are based on [vek280-pre_production BSP](https://www.author.xilinx.com/products/boards-and-kits/vek280.html#tools). Here is the list of additional configurations.

| Configuration                    | Values                                                       | Details |
| -------------------------------- | ------------------------------------------------------------ | ------- |
| Additional Kernel Configurations | CONFIG_CONSOLE_LOGLEVEL_DEFAULT=1                            |         |
| Additional RootFS Components     | DNF<br />e2fsprogs-resize2fs<br />parted<br />xrt, xrt-dev and zocl<br />opencl-clhpp<br />opencl-headers<br />packagegroup-petalinux-opencv<br />>imagefeature-package-management<br />auto-login |         |
| Device Tree Modifications        | Add zocl node for XRT                                       |         |

# Notes

Use the V++ -p option to generate the sd_card.img file that consists rootfs.ext4 provided by petalinux along with the Image,BOOT.BIN and system.dtb from platform, v++ generated xclbin and host.exe files.

Once the Vitis platform is ready, some example applications to build with these platforms can be found here:
https://github.com/Xilinx/Vitis_Accel_Examples
