PLATFORM=<.xpfm PATH>
SYSROOT=<SYSROOT PATH>
CXX:=aarch64-linux-gnu-g++
OS=krnl_pl_to_ps.o
VCC:=v++

.PHONY: all clean

SOURCEDIR = src
SOURCES = $(wildcard ${SOURCEDIR}/*.cpp)

KERN_NAME = krnl_pl_to_ps


KERN_MEM_CONNECT_OPT = --sp ${KERN_NAME}_1.out_r:HP0
KERN_STREAM_CONNECT_OPT = --sc COUNTER:${KERN_NAME}_1.stream_in

all: krnl_pl_to_ps.xclbin host.elf

.PHONY: all clean

krnl_pl_to_ps.xclbin: krnl_pl_to_ps.o
	$(VCC) -l --platform ${PLATFORM} krnl_pl_to_ps.o -t hw -o $@ --save-temps --nk krnl_pl_to_ps:1:krnl_pl_to_ps_1 ${KERN_MEM_CONNECT_OPT} ${KERN_STREAM_CONNECT_OPT}

${KERN_NAME}.o: src/${KERN_NAME}.cpp
	$(VCC) -c --platform ${PLATFORM} $< -o $@ --save-temps

build/%.o: src/%.cpp
	${CXX} -std=c++11 -DDSA64 --sysroot=${SYSROOT} -c $^ -I${SYSROOT}/usr/include/xrt -o $@

host.elf: build/host.o
	${CXX} $^ --sysroot=${SYSROOT} -lxilinxopencl -lxrt_core -o $@

clean:
	rm -rf _x v++_* ${XO} ${OS} *.o.* *.elf build/*.o *.xo.* hw.xclbin hw.xclbin.* *.log Work Map_Repor.csv ilpProblem* sol.db .Xil *.link_summary *.pb *.info *.xclbin *.ltx
