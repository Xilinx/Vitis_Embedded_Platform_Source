set name zcu104_xdf

platform create -name $name -desc "ZCU104 minimum platform" -hw [format [pwd]/platform_repo/tmp/xsa/%s.xsa $name] -prebuilt -out [pwd]/output

domain -name xrt -display-name "A53 XRT Linux" -proc psu_cortexa53 -os linux -image ./platform_repo/tmp/sw_components/image
domain config -boot ./platform_repo/tmp/sw_components/boot
domain config -bif ./platform_repo/tmp/sw_components/boot/petalinux.bif
domain -runtime opencl

platform -generate
