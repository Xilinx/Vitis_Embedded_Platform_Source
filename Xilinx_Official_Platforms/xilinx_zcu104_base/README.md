# Vitis Base Platform for the zcu104 Board

This platform comes with PetaLinux and includes OpenCV. It is useful
as a base platform for exercising Vitis capabilities and topologies on the zcu104 board.

# Building the Platform

**Last Tested Vivado Release: 2021.2**

You can run `make all` to build the platform. Please refer to the [build instructions](../../README.md) chapter for more build options.

## Platform Specification

### General Information

| Type              | Value                       |
| ----------------- | --------------------------- |
| Release Version   | xilinx_zcu104_base_202120_1 |
| Vitis version     | 2021.2                      |
| PetaLinux version | 2021.2                      |
| XRT Tag version   | [202120.2.12.0_Petalinux](https://github.com/Xilinx/XRT/releases/tag/202120.2.12.0_PetaLinux)              |
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

# Notes

Use the V++ -p option to generate the sd_card.img file that consists rootfs.ext4 provided by petalinux along with the Image,BOOT.BIN and system.dtb from platform, v++ generated xclbin and host.exe files.

Once the Vitis platform is ready, some example applications to build with these platforms can be found here:
https://github.com/Xilinx/Vitis_Accel_Examples
