#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

launch_runs impl_1
wait_on_run impl_1
set child_impl_runs [get_runs child_*]
foreach  { impl_run } $child_impl_runs  {
  set_property GEN_FULL_BITSTREAM 1 [get_runs $impl_run]
  launch_runs $impl_run -to_step write_bitstream
  wait_on_run $impl_run
}
