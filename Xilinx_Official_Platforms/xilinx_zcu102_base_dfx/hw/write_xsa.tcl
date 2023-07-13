#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

set PLATFORM_NAME [lindex $argv 0]
open_run impl_1

write_hw_platform -force -hw -include_bit -ext_metadata "${sourcesDir}/misc/ext_metadata.json" -file hw.xsa
write_hwdef -force  -file pfm_top_wrapper.hdf
