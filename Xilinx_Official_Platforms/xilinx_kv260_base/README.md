# Vitis Base Platform for the kv260 Board

***Version: 2025.1***

This platform comes with common hardware features on the kv260 board like GEM and PS DDR4. The platform software includes OpenCV in PetaLinux. It is useful as a base platform for exercising Vitis capabilities and topologies on the kv260 board.

## Platform Specification

### General Information

| Type              | Value                       |
| ----------------- | --------------------------- |
| Release Version   | xilinx_kv260_base_202510_1 |
| Vitis version     | 2025.1                      |
| XRT Tag version   | [202510.2.19.0_PetaLinux](https://github.com/Xilinx/XRT/releases/tag/202510.2.19.0_Petalinux)  |
| Target board      | kv260                      |

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
| Clocks for Kernels            | 150.000 MHz, 300.000 MHz, 75.000 MHz, 100.000 MHz, 200.000 MHz, 400.000 MHz, 600.000 MHz  | Clocks are synchronous to each other|
| SP Tags supported             | DDR, LPDDR                                            | All kernels share same DDR4 and LPDDR4 |
| PS DDR Interfaces for Kernels | HP0, HP1, HP2, HP3, HPC0, HPC1, LPD                   | They share the same PS DDR.         |
| Interrupts                    | 32 Interrupts are enabled from PL Kernel to PS        |                                     |


>Note: This platform is based on CED platform, to get the tcl commands equavalent to platform, please refer to hw/xsa/reference_bd.tcl

### Software Configurations

Go to [Xilinx SOM WIKI page](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/1641152513/Kria+SOMs+Starter+Kits) to  find the software configuration details for both Yocto Linux and Canonical Ubuntu images.

## Build Instructions

Please refer to the [build instructions](../../README.md#build-instructions) in the top README.

## Test the Platform

After successfully building the Vitis platform, you can begin validating it using a sample application.

1. Download a Prebuilt Image
    Go to [Xilinx SOM WIKI page](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/1641152513/Kria+SOMs+Starter+Kits)to download either the Yocto-based prebuilt SD card image or the Canonical Ubuntu image along with the corresponding sysroot, depending on your development preference.

2. Build a Sample Application
    Leverage  the [Vitis Template](https://github.com/Xilinx/vitis_templates/) to build a simple application such as vadd (Vector Addition) to verify platform functionality.

3. Refer to Tutorials for Guidance
    For step-by-step instructions on how to build, run, and validate applications on your platform, refer to [Vitis Tutorial](https://github.com/Xilinx/Vitis-Tutorials) for detailed guidance on platform validation.


