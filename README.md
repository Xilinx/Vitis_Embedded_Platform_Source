Vitis Embedded Platform Source Repository
=========================================

Welcome to the Vitis embedded platform source repository. This repository contains the
source code needed to recreate, modify, and extend the Xilinx-provided Vitis embedded
platforms. To use this source code, you will need to have the following tools installed:

- A Linux-based host OS supported by Vitis and PetaLinux
- Standard GNU build tools (make, etc)
- Vitis 2020.2
- PetaLinux 2020.2 (only required when creating petalinux project instead of using pre-built linux image)

This repository is generally divided into two sections:

- The **Xilinx_Official_Platforms** directory contains official platform source provided by
  Xilinx. These official platforms are fully tested with all official Vitis examples, tutorials,
  etc.

- The **Xilinx_Reference_Platforms** directory contains "unofficial" platform source. These
  platforms generally exist to illustrate particular concepts, provide specific I/O interfaces
  (e.g. MIPI and HDMI), etc. They are tested with the particular examples delivered for those
  platforms and Xilinx makes an effort to ensure compatibility, but they are not regressed
  and tested to the same degree as the official platforms.

# Build Instructions

  Vitis and PetaLinux environment need to be setup before building the platform.

  ```bash
  source <Vitis_install_path>/Vitis/2020.2/settings64.sh
  source <PetaLinux_install_path>/settings.sh
  ```
  This package comes with sources to generate the Vitis platform with these steps:

  1. Generate hardware specification file (XSA) using Vivado.
  2. Generate software components of platform (using either Petalinux or XSCT).
  3. Generate the Vitis platform by packaging hardware and software together using XSCT tool


  - The following table summarizes use cases of platforms build :
    
    - **Pre-Synth XSA** : Hardware specification file (XSA) in these platforms will not have bitstream and generation time of XSA   is quick. By default, Vitis platform Makefile generates pre-synth platforms.
    - **Post-Impl XSA** : XSA in this flow contains PL bitstream in it and generation time will be longer.

  |     | Build Platform with pre-built Linux | Build platform with petalinux |
  | --- | --- | --- |
  | *Introduction:* | This method uses pre-built software components. Time taken for building sw components can be reduced | This method builds all software components. Users can customise software components to have additional libraries, packages etc |
  | *Requirements:* | Common Software. Use Sysroot SDK from Common Software | Petalinux Tool. Install PetaLinux generated SDK for this project |
  | *Pre-Synth command:* | make all PRE_SYNTH=TRUE BOOT_FILES_PATH=\<path/to/boot_files/dir> | make all PRE_SYNTH=TRUE COMMON_RFS_KRNL_SYSROOT=FALSE |
  | *Post-Impl command:* | make all BOOT_FILES_PATH=\<path/to/boot_files/dir> | make all COMMON_RFS_KRNL_SYSROOT=FALSE |

  - The Flags used in commands of above table are explained below :

    - *COMMON_RFS_KRNL_SYSROOT* : Common Linux components are provided as pre-built binaries by Xilinx to fullfill most evaluation requirements. Please refer to [UG1393](https://www.xilinx.com/html_docs/xilinx2020_2/vitis_doc/kme1569523964461.html) - Using Embedded Platforms chapter for more information. Default value of this flag is `TRUE`. To generate linux components locally according to the PetaLinux project sources in this directory, please set this variable to `FALSE`.
      - make all COMMON_RFS_KRNL_SYSROOT=FALSE
    
    - *BOOT_FILES_PATH* : This flag is used in pre-built linux method. It should point to directory containing boot files (u-boot, boot.scr, bl31.elf). Boot files are architecture specific. Zynq, zynqMP and Versal have different boot files. These files can be found in common software.
      - make all BOOT_FILES_PATH=<common_sw_dir>/aarch/xilinx-aarch>
    
    - PRE_SYNTH : This flag is used to specify XSA type that needs to be built. Default value of this flag is `FALSE`. To generate pre-synth xsa, set this variable to `TRUE`
    
    - XSA_DIR : This flag is used when building a platform without modifying anything in XSA.    
      - make linux XSA_DIR=/home/user/<platform_dir>/vivado/build COMMON_RFS_KRNL_SYSROOT=<TRUE/FALSE>
      - make platform

# Installing the Common Software

Common Linux components provided by Xilinx can be downloaded from [Common images section](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html) - Please refer *Common images for Embedded Vitis platforms* section. The common image packages download contains prebuilt linux kernel, boot files, root filesystem and sdk.sh script to generate sysroot.

# Installing the Yocto SDK

A bundled Yocto SDK "sysroot" is not available with this package by default. To build non-trivial Linux software for this platform sysroot need to be built and installed.

This can be done by running the script **sdk.sh** that comes with Common software which can be downloaded as mentioned in above step. 

Also running the command "make petalinux_sysroot" installs sysroot to "platform_repo/sysroot" but this requires petalinux tool to be sourced.

To cross-compile against this platform from the command line, source the environment-setup-\<aarch>-xilinx-linux script to set up your environment (cross compiler, build tools, libraries, etc).
