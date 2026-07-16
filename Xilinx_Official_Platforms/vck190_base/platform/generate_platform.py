#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************
import vitis
import argparse
import os

print("Platform generation")
parser = argparse.ArgumentParser()
parser.add_argument("--xsa_path", type=str, dest="xsa_path")
parser.add_argument("--platform_name", type=str, dest="platform_name")
parser.add_argument("--emu_xsa_path", type=str, dest="emu_xsa_path")
parser.add_argument("--platform_out", type=str, dest="platform_out")
parser.add_argument("--dtb", type=str, dest="dtb")

args = parser.parse_args()
xsa_path=args.xsa_path
platform_name=args.platform_name
emu_xsa_path=args.emu_xsa_path
platform_out=args.platform_out
dtb=args.dtb
print('args',args)
client = vitis.create_client()

client.update_workspace(path=platform_out)

platform = client.create_platform_component(name = platform_name, hw_design = xsa_path, no_boot_bsp = True, emu_design = emu_xsa_path, generate_dtb = False,
 desc = " This platform is a new EDF(Yocto based) platform introduced in 2026.1. The base platform targeting VCK190 which is the first Versal AI Core series evaluation kit, enabling designers to develop solutions using AI and DSP engines capable of delivering over 100X greater compute performance compared to current server class CPUs. This board includes 8GB of DDR4 UDIMM, 8GB LPDDR4 component, 400 AI engines, 1968 DSP engines, Dual-Core Arm® Cortex®-A72 and Dual-Core Cortex-R5. More information at https://www.xilinx.com/products/boards-and-kits/vck190.html" )

platform = client.get_component(name = platform_name)

#aie domain
domain = platform.add_domain(cpu = "ai_engine",os = "aie_runtime",name = "aiengine",display_name = "aiengine")  
domain = platform.get_domain(name="aiengine")  
#linux domain
domain = platform.add_domain(cpu = "psv_cortexa72",os = "linux",name = "xrt",display_name = "xrt")

#status = domain.set_dtb(path=dtb) # used to bypass sdtgen from generate platform

status = platform.build()
