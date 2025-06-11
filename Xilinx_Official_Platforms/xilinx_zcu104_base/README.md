# Vitis Base Platform for the ZCU104 Board

***Version: 2025.1***

This platform comes with common hardware features on the ZCU104 board like GEM and PS DDR4. The platform software includes OpenCV in PetaLinux. It is useful as a base platform for exercising Vitis capabilities and topologies on the ZCU104 board.

## Platform Specification

### General Information

| Type              | Value                       |
| ----------------- | --------------------------- |
| Release Version   | xilinx_zcu104_base_202510_1 |
| Vitis version     | 2025.1                      |
| XRT Tag version   | [202510.2.19.0_PetaLinux](https://github.com/Xilinx/XRT/releases/tag/202510.2.19.0_Petalinux)              |
| Target board      | ZCU104                      |

### Interfaces

| Interface | Region | Details            |
| --------- | ------ | ------------------ |
| UART      | PS     |                    |
| GEM       | PS     |                    |
| USB       | PS     | USB driver enabled |
| SDIO      | PS     |                    |

### Hardware Configurations

| Configuration                 | Values                                                | Details                               |
| ----------------------------- | ----------------------------------------------------- | ------------------------------------- |
| PS DDR Size                   | 2GB                                                   |                                       |
| Clocks for Kernels            | 150MHz, 300MHz, 75MHz, 100MHz, 200MHz, 400MHz, 600MHz | Clocks are synchronous to each other. |
| PS DDR Interfaces for Kernels | HP0, HP1, HP2, HP3, HPC0, HPC1                        | They share the same PS DDR.           |
| Interrupts                    | 32 Interrupts are enabled from PL Kernel to PS        |                                       |

### Software Configurations

The software configurations are based on [ZCU104 BSP](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html). Here is the list of additional configurations.

| Configuration                    | Values                                                       | Details |
| -------------------------------- | ------------------------------------------------------------ | ------- |
| Additional Kernel Configurations | CONFIG_CONSOLE_LOGLEVEL_DEFAULT=1                            |         |
| Additional RootFS Components     | DNF<br />e2fsprogs-resize2fs<br />parted<br />libmali-xlnx: disabled<br />xrt, xrt-dev and zocl<br />opencl-clhpp<br />opencl-headers<br />libdrm, libdrm-tests and libdrm-kms<br />packagegroup-petalinux-audio<br />packagegroup-petalinux-gstreamer<br />packagegroup-petalinux-matchbox<br />packagegroup-petalinux-opencv<br />packagegroup-petalinux-v4lutils<br />packagegroup-petalinux-vitisai<br />packagegroup-petalinux-x11<br />imagefeature-package-management<br />auto-login |         |
| Device Tree Modifications        | Add zocl node for XRT<br />Disable default dtg generated axi intc PL node and add the custom node instead |         |

## Build Instructions

Please refer to the [build instructions](../../README.md#build-instructions) in the top README.

## Test the Platform

Once the Vitis platform build completes, Leverage  the [Vitis Template](https://github.com/Xilinx/vitis_templates/) to build a simple application such as vadd (Vector Addition) to verify platform functionality. 

For step-by-step instructions on how to build, run, and validate applications on your platform, refer to [Vitis Tutorial](https://github.com/Xilinx/Vitis-Tutorials) for detailed guidance on platform validation.