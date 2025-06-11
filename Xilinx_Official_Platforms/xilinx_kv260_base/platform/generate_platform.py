#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************
import vitis
import argparse
import os

print("Platform generation")
parser = argparse.ArgumentParser()
parser.add_argument("--xsa_path", type=str, dest="xsa_path")
parser.add_argument("--platform_name", type=str, dest="platform_name")
#parser.add_argument("--emu_xsa_path", type=str, dest="emu_xsa_path")
parser.add_argument("--platform_out", type=str, dest="platform_out")
#parser.add_argument("--boot_dir_path", type=str, dest="boot_dir_path")
#parser.add_argument("--img_dir_path", type=str, dest="img_dir_path")
#parser.add_argument("--dtb", type=str, dest="dtb")
parser.add_argument("--dtsi", type=str, dest="dtsi")

args = parser.parse_args()
xsa_path=args.xsa_path
platform_name=args.platform_name
#emu_xsa_path=args.emu_xsa_path
platform_out=args.platform_out
#boot_dir_path=args.boot_dir_path
#img_dir_path=args.img_dir_path
#dtb=args.dtb
dtsi=args.dtsi
print('args',args)
import vitis
client = vitis.create_client()
client.update_workspace(path=platform_out)

#platform = client.create_platform_component(name = platform_name, hw_design = xsa_path, no_boot_bsp = True,
# desc = " A base platform targeting kv260 kria SOM" )
#platform = client.create_platform_component(name = platform_name, hw_design = xsa_path, no_boot_bsp = True,
# desc = " A base platform targeting kv260 kria SOM" )

#client.set_workspace(path="test")

advanced_options = client.create_advanced_options_dict(user_dtsi=dtsi,dt_overlay="1",dt_zocl="1")

platform = client.create_platform_component(name = platform_name,hw_design = xsa_path, no_boot_bsp = True,generate_dtb = True, advanced_options = advanced_options,architecture = "64-bit",desc = " A base platform targeting kv260 kria SOM" )

platform = client.get_component(name = platform_name)

# linux domain only since kv260 is non-aie platforms
domain = platform.add_domain(cpu = "psu_cortexa53",os = "linux",name = "xrt",display_name = "xrt", dt_overlay=True )
#domain.set_sd_dir(path = img_dir_path)
domain = platform.get_domain(name="xrt")  
#status = domain.set_boot_dir(path=boot_dir_path)
status = domain.generate_bif()

#status = domain.set_dtb(path=dtb) # used to bypass sdtgen from generate platform

status = platform.build()

