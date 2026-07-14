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
parser.add_argument("--static_xsa_path", type=str, dest="static_xsa_path")
parser.add_argument("--platform_name", type=str, dest="platform_name")
parser.add_argument("--emu_xsa_path", type=str, dest="emu_xsa_path")
parser.add_argument("--platform_out", type=str, dest="platform_out")
parser.add_argument("--boot_dir_path", type=str, dest="boot_dir_path")
parser.add_argument("--img_dir_path", type=str, dest="img_dir_path")
parser.add_argument("--rp_xsa_path", type=str, dest="rp_xsa_path")
parser.add_argument("--user_dtsi", type=str, dest="user_dtsi")
#parser.add_argument("--dtb", type=str, dest="dtb")

args = parser.parse_args()
static_xsa_path=args.static_xsa_path
platform_name=args.platform_name
emu_xsa_path=args.emu_xsa_path
platform_out=args.platform_out
boot_dir_path=args.boot_dir_path
img_dir_path=args.img_dir_path
#dtb=args.dtb
rp_xsa_path=args.rp_xsa_path
user_dtsi=args.user_dtsi
print('args',args)
client = vitis.create_client()
#client.update_workspace(path=os.getcwd()/test)


client.update_workspace(path=platform_out)
#rp_info_args = client.add_rp_info_args(rp_xsa_path=rp_xsa_path)

#platform = client.create_platform_component(name = platform_name, hw_design = static_xsa_path,os = "linux",cpu = "psv_cortexa72",domain_name = "linux_psv_cortexa72",generate_dtb = True,rp_info_args = rp_info_args)

#platform = client.get_component(name=platform_name)

#client.delete_component(name=platform_name)

#advanced_options = client.create_advanced_options_dict(board_dtsi="versal-vck190-reva-x-ebm-01-reva",user_dtsi=$user_dtsi",dt_overlay="0",dt_zocl="1")
advanced_options = client.create_advanced_options_dict(board_dtsi="versal-vck190-reva-x-ebm-01-reva",user_dtsi=user_dtsi,dt_overlay="0",dt_zocl="1")

rp_info_args = client.add_rp_info_args(rp_xsa_path=rp_xsa_path)

#advanced_options = client.create_advanced_options_dict(board_dtsi="versal-vck190-reva-x-ebm-01-reva",user_dtsi=$user_dtsi",dt_overlay="0")
#rp_info_args = client.add_rp_info_args(rp_xsa_path=rp_xsa_path)

platform = client.create_platform_component(name = platform_name,hw_design = static_xsa_path,os = "linux",cpu = "psv_cortexa72",domain_name = "xrt",emu_design = emu_xsa_path,generate_dtb = True, advanced_options = advanced_options, rp_info_args = rp_info_args, desc = " update for vck190_base_dfx latest : A base platform targeting VCK190_BASE_DFX which is the first Versal AI Core series evaluation kit, enabling designers to develop solutions using AI and DSP engines capable of delivering over 100X greater compute performance compared to current server class CPUs. This board includes 8GB of DDR4 UDIMM, 8GB LPDDR4 component, 400 AI engines, 1968 DSP engines, Dual-Core Arm® Cortex®-A72 and Dual-Core Cortex-R5. More information at https://www.xilinx.com/products/boards-and-kits/vck190.html" )

platform = client.get_component(name = platform_name)

#aie domain
domain = platform.add_domain(cpu = "ai_engine",os = "aie_runtime",name = "aiengine",display_name = "aiengine")  
#linux domain
domain = platform.get_domain(name = "xrt")
domain.set_sd_dir(path = img_dir_path)
status = domain.set_boot_dir(path=boot_dir_path)
status = domain.generate_bif()  

#status = domain.set_dtb(path=dtb) # used to bypass sdtgen from generate platform

#status = platform.build()


