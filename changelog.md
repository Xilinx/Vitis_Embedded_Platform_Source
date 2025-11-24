# Change Logs
## 2025.2
- New Platform: `vek385_base`. The new platforms naming convention is updated. Please refer to [UG1701](https://docs.amd.com/r/en-US/ug1701-vitis-accelerated-embedded/Pre-built-Base-Platforms) for details.
- `xilinx_vck190_base_dfx` platform source CED updated to use MBUFGCE to generate clock for AI Engine, aligning with other Versal base platforms.
- Remove `xilinx_zcu104_base` from Xilinx_Official_Platforms after the [deprecation announcement](https://adaptivesupport.amd.com/s/article/000037352?language=en_US). `xilinx_kv260_base` will continue to be supported.

## 2025.1
- `xilinx_vck190_base_dfx` platform updated to use CED to generate hardware platform source.

## 2024.2
- VCK190 base platform updated to use CED to generate hardware platform source code. TCL based source code is also provieded under HW folder for reference.
- Removed BDC platforms
- All Versal platforms updated the dtb generation scripts to make use of newly introduced system device tree flow. 

## 2023.1

- Removed PetaLinux directory from source code.

## 2022.2

- Removed Petalinux based sw components generation from platform creation.

## 2022.1

- VCK190 Base Platform clock frequencies updated to match the fraction of AI Engine clock frequency.
- Added VCK190 Base DFX Platform
- All platforms updated the dtb generation scripts to make use of newly introduced `createdts` command.
- Updated top makefile to use pre-built common image by default.

## 2021.1

- VCK190 Base Platform enables ECC on DDR and LPDDR; constraints become concise.
- MPSoC base platforms increased CMA size to 1536M. All Vitis-AI models can run with this CMA size.
- Embedded platform creation flow gets simplified: Device Tree Generator can automatically generate a ZOCL node; XSCT can generate BIF files. Base platform source files are reduced.