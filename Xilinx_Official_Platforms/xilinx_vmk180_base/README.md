# Vitis Base Platform for the VMK180 Board

***Version: 2022.2***

This platform comes with common hardware features on the VMK180 board like GEM and PS DDR4. The platform software includes OpenCV in PetaLinux. It is useful as a base platform for exercising Vitis capabilities and topologies on the VMK180 board.

## Platform Specification

### General Information

| Type              | Value                       |
| ----------------- | --------------------------- |
| Release Version   | xilinx_vmk180_base_202220_1 |
| Vitis version     | 2022.2                      |
| XRT Tag version   | [202220_2.14.0_Petalinux](https://github.com/Xilinx/XRT/releases/tag/202220_2.14.0_Petalinux)     |
| Target board      | VMK180                      |

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

### Software Configurations

The software configurations are based on [VCK190 Common Image](https://www.author.xilinx.com/member/vck190-ea.html#tools). Here is the list of configurations.

| Configuration                    | Details                                                       | 
| -------------------------------- | ------------------------------------------------------------ | 
| RootFS Components     | Please refer to the **rootfs.manifest** in the Common Image folder for components inside it. |
| Device Tree| User DTS is added in [system-user.dtsi](sw/prebuilt_linux/user_dts/system-user.dtsi) file.|

## Build Instructions

Please refer to the [build instructions](../../README.md#build-instructions) in the top README.

## Test the Platform

Once the Vitis platform build completes, you can use the [Vitis Acceleration examples](https://github.com/Xilinx/Vitis_Accel_Examples) to build with these platforms to test this platform.
