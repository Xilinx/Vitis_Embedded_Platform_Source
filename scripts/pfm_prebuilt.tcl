set name zcu104_xdf

platform -name $name -desc "ZCU104 minimum platform" -hw [format ./dsa/%s.dsa $name] -out ./output

system -name xrt -boot ./sw_platform/boot  -readme ./sw_platform/boot/generic.readme
domain -name xrt -proc psu_cortexa53_0 -os linux -image ./sw_platform/image
boot -bif ./generics/linux/linux.bif

domain -runtime opencl
domain -prebuilt-data ./sw_platform/prebuilt

platform -generate
