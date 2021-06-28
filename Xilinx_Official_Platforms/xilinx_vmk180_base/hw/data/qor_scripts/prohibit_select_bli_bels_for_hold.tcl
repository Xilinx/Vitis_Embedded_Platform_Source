foreach BLI_tile [get_tiles -filter TILE_TYPE=~BLI_?RAM_ROCF_T?_TILE] {
    foreach BLI_bel [get_bels -of $BLI_tile] {
        if {[get_site_pins -quiet -of [get_nodes -quiet -uphill -of [get_nodes -uphill -of [get_nodes -uphill -of [get_nodes -uphill -of [get_site_pins -of [get_bel_pins */D -of $BLI_bel]]]]]] -filter NAME=~*/?_T*] != ""} {
            mark_objects -color red $BLI_bel
            set_property PROHIBIT TRUE $BLI_bel
        }
    }    
}