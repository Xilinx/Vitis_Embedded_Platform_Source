# Vitis Base BDC Platform for the VEK280 ES1 Board

**Note**: The source code for the VEK280 BDC-based platform is currently in the process of preparation and will be released in the near future.

***Version: 2023.2***

This is a block design container (BDC) based platform. It provides the capability to export Vitis-based designs to Vivado for further customizations. It comes with common hardware features on the VEK280 board like AI Engine, GEM, DDR and LPDDR. The platform software includes OpenCV in PetaLinux. It is useful as a base platform for exercising Vitis capabilities and topologies on the VEK280 board. Besides, user could refer to the [Vitis Export to Vivado](https://github.com/Xilinx/Vitis-Tutorials/tree/2023.2/Vitis_Platform_Creation/Feature_Tutorials/03_Vitis_Export_To_Vivado) tutorial for transitioning from an existing flat design to a BDC-based design.

# Building the Platform


The platform build process is entirely scripted. Note that as this platform
build process involves cross-compiling Linux, build of the platform is supported
on Linux environments **only** (although it is possible to build inside a VM or
Docker container).

After cloning the platform source, and with Vivado set up, run `make` command
with appropriate flags from the top-level platform directory.

Note that by default this Makefile will install the platform to "platform_repo/xilinx_vek280_es1_base_202320_1/export/xilinx_vek280_es1_base_202320_1/"

## Platform Specification

### General Information

| Type            | Value                                                                                         |
| --------------- | --------------------------------------------------------------------------------------------- |
| Release Version | xilinx_vek280_es1_base_bdc_202320_1                                                           |
| Vitis version   | 2023.2                                                                                        |
| XRT Tag version | [202320.2.16.0_PetaLinux](https://github.com/Xilinx/XRT/releases/tag/202320.2.16.0_PetaLinux) |
| Target board    | VEK280                                                                                        |

### Interfaces

| Interface | Region | Details            |
| --------- | ------ | ------------------ |
| UART      | PS     |                    |
| GEM       | PS     |                    |
| USB       | PS     | USB driver enabled |
| SDIO      | PS     |                    |

### Hardware Configurations

| Configuration                     | Values                                                | Details                              |
| --------------------------------- | ----------------------------------------------------- | ------------------------------------ |
| LPDDR Size                        | 12GB                                                  |                                      |
| Clocks for Kernels                | 150MHz, 100MHz, 300MHz, 75MHz, 200MHz, 400MHz, 600MHz | Clocks are synchronous to each other |
| SP Tags supported                 | LPDDR                                                 | All kernels share same LPDDR4        |
| Interrupts                        | 32 interrupts are enabled from PL Kernel to PS        |                                      |
| AXI Interfaces for Kernel Control | 28 M_AXI_GP AXI interfaces are enabled                |                                      |
| AI Engine                         | Enabled                                               |                                      |

### Software Configurations

The software configurations are based on [vek280-es1 BSP](https://www.author.xilinx.com/products/boards-and-kits/vek280.html#tools). Here is the list of additional configurations.

| Configuration                    | Values                                                                                                                                                                                             | Details |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| Additional Kernel Configurations | CONFIG_CONSOLE_LOGLEVEL_DEFAULT=1                                                                                                                                                                  |         |
| Additional RootFS Components     | DNF<br />e2fsprogs-resize2fs<br />parted<br />xrt, xrt-dev and zocl<br />opencl-clhpp<br />opencl-headers<br />packagegroup-petalinux-opencv<br />>imagefeature-package-management<br />auto-login |         |
| Device Tree Modifications        | Add zocl node for XRT                                                                                                                                                                              |         |

# Notes

Use the V++ -p option to generate the sd_card.img file that consists rootfs.ext4 provided by petalinux along with the Image,BOOT.BIN and system.dtb from platform, v++ generated xclbin and host.exe files.

Once the Vitis platform is ready, some example applications to build with these platforms can be found here:
https://github.com/Xilinx/Vitis_Accel_Examples


## Limitations
1. Trace offload through High Speed Debug Port (HDSP) is not supported with this platform. 
2. While using the trace option, it's recommended to use --num-trace-streams=8 (or lower) as the option to aie-compiler (need to check if this should be v++ -mode aie )
3. In some cases, special attention should be paid to resultant Vivado designs.
    - The usage of Flip Flops and LUTs in the resultant Vivado design might be higher than non-BDC based platforms. User should check the usage of resources as per their design
    - The achieved Fmax for designs can be slightly lower than non-BDC based designs.