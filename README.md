Vitis Embedded Platform Source Repository
=========================================

Welcome to the Vitis embedded platform source repository. This repository contains the
source code needed to recreate, modify, and extend the Xilinx-provided Vitis embedded
platforms. To use this source code, you will need to have the following tools installed:

- A Linux-based host OS supported by Vitis and PetaLinux
- Standard GNU build tools (make, etc)
- Vitis 2019.2
- PetaLinux 2019.2

This repository is generally divided into two sections:

- The **Xilinx_Official_Platforms** directory contains official platform source provided by
  Xilinx. These official platforms are fully tested with all official Vitis examples, tutorials,
  etc.

- The **Xilinx_Reference_Platforms** directory contains "unofficial" platform source. These
  platforms generally exist to illustrate particular concepts, provide specific I/O interfaces
  (e.g. MIPI and HDMI), etc. They are tested with the particular examples delivered for those
  platforms and Xilinx makes an effort to ensure compatibility, but they are not regressed
  and tested to the same degree as the official platforms.

For build instructions on any particular platform, please refer to the README in the root
directory of the platform source.
