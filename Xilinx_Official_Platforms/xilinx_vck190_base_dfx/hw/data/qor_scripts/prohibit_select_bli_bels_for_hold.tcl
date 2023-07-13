#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2023 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************

foreach BLI_tile [get_tiles -filter TILE_TYPE=~BLI_?RAM_?OCF_T?_TILE] {
    foreach BLI_bel [get_bels -of $BLI_tile] {
        if {[get_site_pins -quiet -of [get_nodes -quiet -uphill -of [get_nodes -quiet -uphill -of [get_nodes -quiet -uphill -of [get_nodes -quiet -uphill -of [get_site_pins -quiet -of [get_bel_pins -quiet */D -of $BLI_bel]]]]]] -filter NAME=~*/?_T*] != ""} {
            set_property PROHIBIT TRUE $BLI_bel
        }
    }   
}
#Set the clibrated dskew clock to off 
#set_property GCLK_DESKEW Off [get_nets -of [get_pins -of [get_cells -hier -filter PRIMITIVE_TYPE=~CLOCK.BUFFER.*] -filter DIRECTION==OUT]]
