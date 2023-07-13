#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

# Floorplanning
# ------------------------------------------------------------------------------

#placeholder
#set_false_path -to [get_pins -hierarchical -filter \{NAME =~ pfm_top_i/static_region/axi_intc_0/U0/INTC_CORE_I/*/D}]
set_property BEL MMCM [get_cells pfm_top_i/static_region/base_clocking/clkwiz_sysclks/inst/mmcme4_adv_inst]
set_property LOC MMCM_X0Y2 [get_cells pfm_top_i/static_region/base_clocking/clkwiz_sysclks/inst/mmcme4_adv_inst]
