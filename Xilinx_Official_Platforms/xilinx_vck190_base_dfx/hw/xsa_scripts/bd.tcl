#******************************************************************************
# Copyright (C) 2020-2022 Xilinx, Inc. All rights reserved.
# Copyright (C) 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#******************************************************************************
################################################################
# This is a generated script based on design: vitis_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

set_property board_part xilinx.com:vck190:part0:* [current_project]

# Instatiate CED design with configurable properties


proc assign_bdc_apertures {rm_bd top_bd bdc_cell} {
  set old_bd [current_bd_design]
  open_bd_design ${rm_bd}
  set aps [dict create]
  foreach x [get_bd_intf_ports] {
    set apertures [get_property -quiet APERTURES ${x}]
    if {[string length ${apertures}] > 0} {
      dict set aps [::bd::utils::get_short_name ${x}] ${apertures}
    }
  }
  open_bd_design ${top_bd}
  foreach {intf apertures} ${aps} {
    set_property APERTURES ${apertures} [get_bd_intf_pins [get_bd_cells ${bdc_cell}]/${intf}]
  }
  current_bd_design ${old_bd}
}

instantiate_example_design -template xilinx.com:design:versal_dfx_platform:1.0 -design vitis_design -options { Clock_Options.VALUE {clk_out1 625 0 true clk_out2 100.000 1 false} Include_AIE.VALUE true IRQS.VALUE 32}

assign_bdc_apertures [get_files VitisRegion.bd] [get_files vitis_design.bd] VitisRegion

validate_bd_design
save_bd_design

update_compile_order -fileset sim_1
update_compile_order -fileset sources_1

