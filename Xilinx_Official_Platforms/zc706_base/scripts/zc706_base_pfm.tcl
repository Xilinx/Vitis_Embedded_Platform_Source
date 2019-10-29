set platform_name [lindex $argv 0]
puts "The platform name is \"$platform_name\""

set xsa_path [lindex $argv 1]
puts "The xsa path is \"$xsa_path\"" 
set OUTPUT platform_repo
set SW_COMP platform_repo/tmp/sw_components/

platform -name $platform_name -desc "Basic platform targeting the zc706 board, which includes 1GB of DDR3, 16MB Quad-SPI Flash and an SDIO card interface. More information at https://www.xilinx.com/products/boards-and-kits/ek-z7-zc706-g.html" -hw $xsa_path/$platform_name.xsa -out ./$OUTPUT

domain -name xrt -proc ps7_cortexa9 -os linux -image $SW_COMP/src/a9/xrt/image
domain config -boot $SW_COMP/src/boot
domain config -bif $SW_COMP/src/a9/xrt/linux.bif
domain -runtime opencl
domain -pmuqemu-args $SW_COMP/src/qemu/lnx/pmu_args.txt
domain -qemu-args $SW_COMP/src/qemu/lnx/qemu_args.txt
domain -qemu-data $SW_COMP/src/boot
#domain -sysroot ./src/aarch64-xilinx-linux

platform -generate

