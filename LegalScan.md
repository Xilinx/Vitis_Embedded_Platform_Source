Legal Scan For Release
=========================================

## Binary Files ##

Linux kernel and rootfs are no longer shipped with embedded platforms starting with 2020.1.

### Boot SW binaries ###
BOOT files like uboot.elf, bl21.elf, pmufw.elf, etc are shipped in the sw folder of the platforms and
 need to go through legal review. These files are created by petalinux. Need to capture details of git repo path of sources of the elf files, and also send a locally downloaded zip containign the sources and send to legal team (Parisa, Jeff for DCG).

### BOOT.BIN ###
For DFX platforms, the BOOT.BIN content also needs to go through legal review. This is built from the platform sources directly. Hence, its easy to get legal revies of this.

## Updating Sources on Public Github ##

Sources need to be merged from gitenterprise to public github repo. There is separate branch for each release. The "master" branch is not used. As an example, for 2020.1 release, merge was done from https://gitenterprise.xilinx.com/swm/Vitis_Embedded_Platform_Source/tree/2020.1/Xilinx_Official_Platforms to https://github.com/Xilinx/Vitis_Embedded_Platform_Source/tree/2020.1/Xilinx_Official_Platforms

This is typically done by marketing team (rickysu) at the time of release.
