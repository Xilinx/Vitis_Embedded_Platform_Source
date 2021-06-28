set platform_name [lindex $argv 0]
puts "The platform name is \"$platform_name\"" 

set xsa_path [lindex $argv 1]
puts "The xsa path is \"$xsa_path\"" 

set sw_component [lindex $argv 2]
puts "The sw comp path is \"$sw_component\""

set output_path [lindex $argv 3]
puts "The output path is \"$output_path\""

platform -name $platform_name -desc "A basic platform targeting the ZCU102 evaluation board, which includes 4GB of DDR4 for the Processing System, 512MB of DDR4 for the Programmable Logic, 2x64MB Quad-SPI Flash and an SDIO card interface. More information at https://www.xilinx.com/products/boards-and-kits/ek-u1-zcu102-g.html" -hw $xsa_path/$platform_name.xsa -out $output_path -no-boot-bsp 

domain -name xrt -proc psu_cortexa53 -os linux -sd-dir $sw_component/platform/image
domain config -boot $sw_component/platform/boot
domain config -generate-bif
domain -runtime opencl
domain -pmuqemu-args $sw_component/platform/qemu/lnx/pmu_args.txt
domain -qemu-args $sw_component/platform/qemu/lnx/qemu_args.txt
domain -qemu-data $sw_component/platform/boot
#domain -sysroot ./src/aarch64-xilinx-linux

platform -generate
