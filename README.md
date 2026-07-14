# Vitis Embedded Platform Source Repository

This repository contains the source code to recreate, modify, and extend the
[AMD Vitis Embedded Platforms](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-platforms.html).

## Prerequisites

- Linux host OS [supported by Vitis](https://docs.amd.com/r/en-US/ug1393-vitis-application-acceleration/Installation-Requirements)
- [Vitis 2026.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis.html)
- [Common Software Image 2026.1](#installing-the-common-software) (PetaLinux flow only)

> By using these platform sources you agree to the [AMD End User License Agreement](https://account.amd.com/content/dam/account/en/licenses/download/amd-end-user-license-agreement.pdf).

## Available Platforms

### Embedded Development Flow (EDF) Platforms (Recommended for New Designs)

| Platform | Board | Description |
|---|---|---|
| `vek385_base` | VEK385 | Versal AI Edge Gen2 base platform |
| `vrk160_base` | VRK160 | Versal AI RF base platform |
| `vck190_base` | VCK190 | Versal AI Core base platform |
| `vek280_base` | VEK280 | Versal AI Edge base platform |
| `kv260_base` | KV260 | Kria SOM base platform |

### PetaLinux Flow Platforms

| Platform | Board | Description |
|---|---|---|
| `xilinx_vck190_base_202610_1` | VCK190 | Versal AI Core base platform |
| `xilinx_vek280_base_202610_1` | VEK280 | Versal AI Edge base platform |
| `xilinx_vck190_base_dfx_202610_1` | VCK190 | Versal AI Core DFX platform |

## Build Instructions

Set up the Vitis environment before building any platform:

```bash
source <Vitis_install_path>/Vitis/2026.1/settings64.sh
```

> **Note:** Platform builds are supported on Linux **only** (VM or Docker container is acceptable).

### Building EDF-Based Platforms

For EDF-based platforms, refer to the [Vitis Tutorials](https://github.com/Xilinx/Vitis-Tutorials) for step-by-step guidance. Pre-built EDF artifacts are also available from the [AMD Embedded Development Framework download page](https://authorwww.amd.com/en/products/software/adaptive-socs-and-fpgas/embedded-software/embedded-development-framework.html).

> **Note:** For platforms with a two-stage boot flow (e.g., VRK160), the first stage boots from OSPI. Update the OSPI image files with the boot images generated when you build or package your system project in the Vitis Unified IDE.

### Building PetaLinux-Based Platforms

The build flow generates a Vitis platform in three steps:

1. Generate hardware specification file (XSA) using Vivado
2. Generate software components (using XSCT)
3. Package hardware and software into a Vitis platform (using XSCT)

#### Quick Start

```bash
# Build with pre-built Linux from default path (/opt/xilinx/platform/xilinx-<arch>-common-<ver>)
make all

# Build with pre-built Linux from a custom path
make all PREBUILT_LINUX_PATH=<path/to/common_sw/dir>

# Build with post-implementation XSA (required for DFX platforms)
make all PRE_SYNTH=FALSE PREBUILT_LINUX_PATH=<path/to/common_sw/dir>
```

The built platform output is located at `platform_repo/<platform_name>/export/<platform_name>/`.

#### Build Options

| Flag | Default | Description |
|---|---|---|
| `PREBUILT_LINUX_PATH` | `/opt/xilinx/platform/xilinx-<arch>-common-<ver>` | Path to pre-built common software directory containing `u-boot.elf`, `boot.scr`, and `bl31.elf`. These files are architecture-specific (Zynq, ZynqMP, and Versal use different components). |
| `PRE_SYNTH` | `TRUE` | Set to `FALSE` to generate a post-implementation XSA (includes bitstream, longer build time). Required for DFX platforms. |
| `XSA` | *(none)* | Path to a pre-built XSA file. Use when building a platform from an existing XSA. |

**Using a pre-built XSA:**

```bash
make linux XSA=/home/user/<platform_dir>/vivado/build/<platform_name>.xsa
make platform
```

#### XSA Types

- **Pre-Synth XSA** (default): Does not contain a bitstream. Faster to generate. Not valid for DFX platforms.
- **Post-Impl XSA**: Runs through Vivado implementation and includes the PL bitstream. Required for DFX platforms. For flat platforms, this allows early detection of implementation issues and provides resource info via `platforminfo`.

> **Note:** For Versal platforms, the PDI in XSA is always a pre-synth PDI.

#### Software Preparation Methods

There are two ways to prepare the platform software:

1. **Pre-built Common Images (recommended):** Download and install the [Common Software Image](#installing-the-common-software). This skips PetaLinux project creation and significantly reduces build time.

2. **PetaLinux (for customization):** Build everything locally with PetaLinux for full customization of software components. See the [PetaLinux Customization Tutorial](https://github.com/Xilinx/Vitis-Tutorials/tree/master/Vitis_Platform_Creation/Feature_Tutorials/02_petalinux_customization) for details.

## Installing the Common Software

AMD provides pre-built Common Software images so you can skip PetaLinux project creation for common use cases. Download from the AMD Download Center:

- [Embedded Platforms tab](https://www.amd.com/en/support/downloads/adaptive-socs-and-fpgas/development-tools/2026-1.html)

Look for the **Common images for Embedded Vitis platforms** section.

The download package contains:

- Pre-built Linux kernel
- Pre-built root file system
- `sdk.sh` to generate sysroot
- Boot files (`u-boot.elf`, `boot.scr`, `bl31.elf`, etc.)

Extract and install:

```bash
tar -xzf xilinx-<arch>-common-<version>.tar.gz
```

Place the extracted files at `/opt/xilinx/platform/` (default path), or pass a custom path via the `PREBUILT_LINUX_PATH` flag during build.

> **Note:** For Ubuntu-based application development, download Ubuntu images from [Canonical](https://ubuntu.com/download/amd).

## Installing the Sysroot 

Vitis applications require libraries from the sysroot for cross-compilation. The sysroot is **not required** for building base platforms — only for building Vitis applications that target those platforms.

The `sdk.sh` script is included in the Common Software image package. Run it to install:

```bash
# Interactive install
./sdk.sh

# Non-interactive install to a specific directory
./sdk.sh -y -d <install_dir>
```

After installation, set up the cross-compilation environment:

```bash
source <sysroot_install_dir>/environment-setup-*-xilinx-linux
```

> **Note:** For Ubuntu-based application development, download the sysroot from [Canonical](https://ubuntu.com/download/amd).
