#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************
################################################################

# Instatiate CED design with configurable properties

instantiate_example_design -template xilinx.com:design:edf_base:1.0 -design vitis_design

validate_bd_design
save_bd_design

update_compile_order -fileset sim_1
update_compile_order -fileset sources_1

