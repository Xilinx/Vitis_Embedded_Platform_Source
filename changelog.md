# Change Logs

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
