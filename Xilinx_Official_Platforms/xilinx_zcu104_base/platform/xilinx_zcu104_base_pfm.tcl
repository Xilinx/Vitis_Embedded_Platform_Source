set platform_name [lindex $argv 0]
puts "The platform name is \"$platform_name\"" 

set xsa_path [lindex $argv 1]
puts "The xsa path is \"$xsa_path\"" 

set sw_component [lindex $argv 2]
puts "The sw comp path is \"$sw_component\""

set output_path [lindex $argv 3]
puts "The output path is \"$output_path\""

platform -name $platform_name -desc "A basic static platform targeting the ZCU104 evaluation board, which includes 2GB DDR4, GEM, USB, SDIO interface and UART of the Processing System. It reserves most of the PL resources for user to add acceleration kernels" -hw $xsa_path/$platform_name.xsa -out $output_path -no-boot-bsp

domain -name xrt -proc psu_cortexa53 -os linux -sd-dir $sw_component/platform/image
domain config -boot $sw_component/platform/boot
domain config -generate-bif
domain -runtime opencl
domain -pmuqemu-args $sw_component/platform/qemu/lnx/pmu_args.txt
domain -qemu-args $sw_component/platform/qemu/lnx/qemu_args.txt
domain -qemu-data $sw_component/platform/boot
#domain -sysroot ./src/aarch64-xilinx-linux

platform -generate
