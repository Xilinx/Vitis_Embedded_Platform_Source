#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
generate_target all [get_files pfm_top.bd]
launch_runs synth_1 -jobs 16
wait_on_run synth_1
set proj_pr_flow [get_property PR_FLOW [current_project]]
if {$proj_pr_flow == 1} {
  setup_pr_configuration -v
}
