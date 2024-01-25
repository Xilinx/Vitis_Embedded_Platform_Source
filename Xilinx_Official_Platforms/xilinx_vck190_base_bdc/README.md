# Vitis Base Platform for the VCK190 Board

***Version: 2023.2***

This is a block design container (BDC) based platform. It provides the capability to export Vitis-based designs to Vivado for further customizations. It comes with common hardware features on the VCK190 board like AI Engine, GEM, DDR and LPDDR. The platform software includes OpenCV in pre-built Common Image. It is useful as a base platform for exercising Vitis capabilities and topologies on the VCK190 board. Besides, user could refer to the [Vitis Export to Vivado](https://github.com/Xilinx/Vitis-Tutorials/tree/2023.2/Vitis_Platform_Creation/Feature_Tutorials/03_Vitis_Export_To_Vivado) tutorial for transitioning from an existing flat design to a BDC-based design.

## Platform Specification

### General Information

| Type              | Value                       |
| ----------------- | --------------------------- |
| Release Version   | xilinx_vck190_base_bdc_202320_1 |
| Vitis version     | 2023.2                      |
| XRT Tag version   | [202320.2.16.0_PetaLinux](https://github.com/Xilinx/XRT/releases/tag/202320.2.16.0_PetaLinux)              |
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
| Clocks for Kernels            | 156.25MHz, 104.166MHz, 312.5MHz, 78.125MHz, 208.33MHz, 416.66MHz, 625MHz | Clocks are synchronous to each other|
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

## Build Instructions

Please refer to the [build instructions](../../README.md#build-instructions) in the top README.

## Test the Platform
Once the Vitis platform build completes, you can use the [Vitis Acceleration examples](https://github.com/Xilinx/Vitis_Accel_Examples) to build with these platforms to test this platform.
  

## Limitations
1. Trace offload through High Speed Debug Port (HDSP) is not supported with this platform. 
2. While using the trace option, it's recommended to use --num-trace-streams=8 (or lower) as the option to aie-compiler (need to check if this should be v++ -mode aie )
3. In some cases, special attention should be paid to resultant Vivado designs.
    - The usage of Flip Flops and LUTs in the resultant Vivado design might be higher than non-BDC based platforms. User should check the usage of resources as per their design
    - The achieved Fmax for designs can be slightly lower than non-BDC based designs.