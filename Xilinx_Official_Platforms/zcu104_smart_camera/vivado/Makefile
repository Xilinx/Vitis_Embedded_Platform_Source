OUTPUT=../platform_repo/tmp
HW_PATH=$(OUTPUT)/vivado
VIVADO=$(XILINX_VIVADO)/bin/vivado

.phony: all

all: hw

hw:
	mkdir -p $(HW_PATH)
	$(VIVADO) -mode batch -notrace -source $(PLATFORM)_xsa.tcl

clean:
	$(RM) -r vivado.* $(PLATFORM) $(PLATFORM).xsa .Xil xilinx_zcu102_dynamic_0_1 emu_overlay hd_visual *.hdf
	
