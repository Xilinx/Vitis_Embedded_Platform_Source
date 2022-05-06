# Vitis Base Platform for the ZCU102 Board

***Version: 2022.1***

This platform comes with common hardware features on the ZCU102 board like GEM and PS DDR4. The platform software includes OpenCV in PetaLinux. It is useful as a base platform for exercising Vitis capabilities and topologies on the ZCU102 board.

## Platform Specification

### General Information

| Type              | Value                       |
| ----------------- | --------------------------- |
| Release Version   | xilinx_zcu102_base_202210_1 |
| Vitis version     | 2022.1                      |
| PetaLinux version | 2022.1                      |
| XRT Tag version   | [202210_2.13.0_Petalinux](https://github.com/Xilinx/XRT/releases/tag/202210_2.13.0_Petalinux)              |
| Target board      | ZCU102                      |

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
| PS DDR Size                   | 2GB                                                   |                                     |
| Clocks for Kernels            | 150MHz, 300MHz, 75MHz, 100MHz, 200MHz, 400MHz, 600MHz | Clocks are synchronous to each other|
| PS DDR Interfaces for Kernels | HP0, HP1, HP2, HP3, HPC0, HPC1, LPD                   | They share the same PS DDR.         |
| Interrupts                    | 32 Interrupts are enabled from PL Kernel to PS        |                                     |

### Software Configurations

The software configurations are based on [ZCU102 BSP](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html). Here is the list of additional configurations.

| Configuration                    | Values                                                       | Details |
| -------------------------------- | ------------------------------------------------------------ | ------- |
| Additional Kernel Configurations | CONFIG_CONSOLE_LOGLEVEL_DEFAULT=1                            |         |
| Additional RootFS Components     | DNF<br />e2fsprogs-resize2fs<br />parted<br />libmali-xlnx: disabled<br />xrt, xrt-dev and zocl<br />opencl-clhpp<br />opencl-headers<br />libdrm, libdrm-tests and libdrm-kms<br />packagegroup-petalinux-audio<br />packagegroup-petalinux-gstreamer<br />packagegroup-petalinux-matchbox<br />packagegroup-petalinux-opencv<br />packagegroup-petalinux-v4lutils<br />packagegroup-petalinux-vitisai<br />packagegroup-petalinux-x11<br />imagefeature-package-management<br />auto-login |         |
| Device Tree Modifications        | Add zocl node for XRT<br />Disable default dtg generated axi intc PL node and add the custom node instead |         |

## Build Instructions

Please refer to the [build instructions](../../README.md#build-instructions) in the top README.

## Test the Platform

Once the Vitis platform build completes, you can use the [Vitis Acceleration examples](https://github.com/Xilinx/Vitis_Accel_Examples) to build with these platforms to test this platform.
