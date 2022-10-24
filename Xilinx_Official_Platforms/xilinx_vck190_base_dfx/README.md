# Vitis Base DFX Platform for the vck190 Board

***Version: 2022.2***

This platform comes with common hardware features on the VCK190 board like AI Engine, GEM, DDR and LPDDR. The platform software includes OpenCV in PetaLinux. It is useful as a base platform for exercising Vitis capabilities and topologies on the VCK190 board.

This platform supports Dynamic Function eXchange feature. Users can switch xclbin (acceleration kernel container for AI Engine and PL) without rebooting the system.

## Platform Specification

### General Information

| Type              | Value                           |
| ----------------- | ---------------------------     |
| Release Version   | xilinx_vck190_base_dfx_202220_1 |
| Vitis version     | 2022.2                          |
| XRT Tag version   | [202220_2.14.0_Petalinux](https://github.com/Xilinx/XRT/releases/tag/202220_2.14.0_Petalinux)              |
| Target board      | VCK190                          |

Supported DFX Features

- PL kernel logic and AI Engine application defined by application developers can be reconfigured during runtime.

Limitations

- Only one recongiratuion region can be defined in the platform. It can contain AI Engine and PL. All resources in the reconfigurable region needs to be swap as a whole.
- Hardware emulation supports emulating the first configuration. The reconfiguration behavior is not supported in emulation. Further reconfiguration modules can not be emulated in the same hw-emu process.

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
| Interrupts                    | 32 interrupts are enabled from PL Kernel to PS        |                                     |
| AXI Interfaces for Kernel Control | 28 M_AXI_GP AXI interfaces are enabled            |                                     |
| AI Engine                     | Enabled                                               |                                     |

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
