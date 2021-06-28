set platform_name [lindex $argv 0]
puts "The platform name is \"$platform_name\""

set xsa_path [lindex $argv 1]
puts "The xsa path is \"$xsa_path\""

set sw_component [lindex $argv 2]
puts "The sw comp path is \"$sw_component\""

set output_path [lindex $argv 3]
puts "The output path is \"$output_path\""


platform create -name $platform_name -desc " A base platform targeting VMK180 .This board includes 8GB of DDR4 UDIMM, 8GB LPDDR4 component, 1968 DSP engines, Dual-Core Arm® Cortex®-A72 and Dual-Core Cortex-R5. More information at https://www.xilinx.com/products/boards-and-kits/vmk180.html" -hw $xsa_path/$platform_name.xsa -out $output_path -no-boot-bsp
domain create -name xrt -proc psv_cortexa72 -os linux -sd-dir $sw_component/platform/image
domain config -boot $sw_component/platform/boot
domain config -generate-bif

domain config -pmcqemu-args $sw_component/platform/qemu/lnx/pmc_args.txt
domain config -qemu-args $sw_component/platform/qemu/lnx/qemu_args.txt
domain config -qemu-data $sw_component/platform/boot

platform generate
