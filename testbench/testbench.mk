TOPLEVEL_LANG = verilog
VERILOG_SOURCES = $(shell pwd)/linearregression.sv
TOPLEVEL = top_module
MODULE = testbench
SIM = verilator
EXTRA_ARGS += --trace --trace-structs -Wno-fatal
include $(shell cocotb-config --makefiles)/Makefile.sim