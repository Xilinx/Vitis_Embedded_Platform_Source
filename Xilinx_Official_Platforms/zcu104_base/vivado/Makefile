OUTPUT=../platform_repo/tmp
HW_PATH=$(OUTPUT)/vivado
VIVADO=$(XILINX_VIVADO)/bin/vivado

all: hw

hw:
	mkdir -p $(HW_PATH)
	$(VIVADO) -mode batch -notrace -source $(PLATFORM)_xsa.tcl

clean:
	$(RM) -r vivado.* $(PLATFORM) $(PLATFORM).xsa  zcu104_base xilinx_zcu104_base_202010_1 xilinx_zcu104_base_202010_1.xsa .Xil

