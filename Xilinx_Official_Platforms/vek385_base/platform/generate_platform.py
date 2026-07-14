#*******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#*******************************************************************************
import vitis
import argparse
import os

print("Platform generation")
parser = argparse.ArgumentParser()
parser.add_argument("--xsa_path", type=str, dest="xsa_path")
parser.add_argument("--platform_name", type=str, dest="platform_name")
parser.add_argument("--emu_xsa_path", type=str, dest="emu_xsa_path")
parser.add_argument("--platform_out", type=str, dest="platform_out")
parser.add_argument("--boot_dir_path", type=str, dest="boot_dir_path")
parser.add_argument("--img_dir_path", type=str, dest="img_dir_path")
parser.add_argument("--dtb", type=str, dest="dtb")

args = parser.parse_args()
xsa_path=args.xsa_path
platform_name=args.platform_name
emu_xsa_path=args.emu_xsa_path
platform_out=args.platform_out
boot_dir_path=args.boot_dir_path
img_dir_path=args.img_dir_path
dtb=args.dtb
print('args',args)



client = vitis.create_client()
client.update_workspace(path=platform_out)

advanced_options = client.create_advanced_options_dict(dt_overlay="1",dt_zocl="1")

platform = client.create_platform_component(name = platform_name, hw_design = xsa_path, emu_design = emu_xsa_path, no_boot_bsp = True, generate_dtb = False,
 desc = " The VEK385 Vitis base platform is designed for the VEK385 evaluation kit, enabling developers to create high-performance applications using AI and DSP engines that deliver over 10× the scalar compute performance of current server-class CPUs. This platform features a powerful heterogeneous architecture with 8 Arm® Cortex®-A78 application processors, 10 Arm® Cortex®-R5 real-time processors, and 20GB of high-speed LPDDR5X memory. It offers a robust foundation for building advanced solutions in AI, signal processing, and compute-intensive domains using AMD Versal™ adaptive SoCs." )


platform = client.get_component(name=platform_name)

#aie domain
domain = platform.add_domain(cpu = "ai_engine",os = "aie_runtime",name = "aiengine",display_name = "aiengine")  
domain = platform.get_domain(name="aiengine")  
#linux domain
domain = platform.add_domain(os = "linux",cpu = "cortexa78",name = "xrt",display_name = "xrt", generate_dtb = False)

status = platform.build()

