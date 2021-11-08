# Change Logs

## 2021.2

- Hardware XSA and hardware emulation XSA (optional) files are generated seperatedly in Vivado. Combined XSA are no longer used. During platform creation step, in the XSCT script, it reads in hw.xsa and hw_emu.xsa if it exists, assign them with `-hw` and `-hw_emu` options and generate the platform. When building the acceleration application with the platform, these XSA files will be used according to the application build target. Vivado and XSCT will deprecate combined XSA feature in the future.
- All makefiles in platform source become more generic. You can pass custom XSA files to makefile to generate the platform with pre-defined software settings. For example `make linux XSA=<custom>.xsa; make platform`. The input XSA will be used as hardware XSA.

## 2021.1

- VCK190 Base Platform enables ECC on DDR and LPDDR; constraints become concise.
- MPSoC base platforms increased CMA size to 1536M. All Vitis-AI models can run with this CMA size.
- Embedded platform creation flow gets simplified: Device Tree Generator can automatically generate a ZOCL node; XSCT can generate BIF files. Base platform source files are reduced.
