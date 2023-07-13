#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

# Skip BD supported IP check
set_param bd.skipSupportedIPCheck true

# Set HIP SLR automation level
set __sdx_hip_slr_automation_level 2
if {[info exists ::env(SDX_HIP_SLR_AUTOMATION_LEVEL)]} {
  set __sdx_hip_slr_automation_level $::env(SDX_HIP_SLR_AUTOMATION_LEVEL)
}
set_param ips.enableSLRParameter $__sdx_hip_slr_automation_level

