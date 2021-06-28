VIVADO = $(XILINX_VIVADO)/bin/vivado
TCL_SOURCE=project.tcl
CWD = $(shell readlink -f .)

TOP_DIR = $(CWD)/../
include $(TOP_DIR)/platform.mk

.PHONY: all xsa
all xsa : $(XSA)

$(XSA): $(TCL_SOURCE)
	$(VIVADO) -mode batch -notrace -source $(TCL_SOURCE) -tclargs $(PLATFORM_NAME) $(VER)

clean:
	$(RM) -r vivado* build .Xil *dynamic* *.log *.xpe 
