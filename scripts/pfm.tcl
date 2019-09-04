set name zcu104_min

platform create -name $name -desc "ZCU104 minimum platform" -hw [format ./dsa/%s.xsa $name] -out ./output

domain create -name xrt -proc psu_cortexa53_0 -os linux
domain config -readme ./sw_platform/boot/generic.readme

domain config -image ./sw_platform/image
domain config -boot ./sw_platform/boot
domain config -bif ./generics/linux/linux.bif
domain config -runtime opencl

platform -generate
