
VIP_DIR=$(FPRO_DIR)/hw/vip
IP_DIR= $(FPRO_DIR)/hw/ip

GPI_DIR=$(IP_DIR)/gpi

VMOD_DIR=$(GPI_DIR)/vmod
DV_DIR=$(GPI_DIR)/dv

all: apb rtl tb top

apb: 
	vlog $(VIP_DIR)/apb/apb_pkg.sv

rtl:
	vlog $(VMOD_DIR)/gpi.sv

tb: seq env test

seq:
	vlog $(DV_DIR)/seq/seq_pkg.sv

env:
	vlog $(DV_DIR)/tb/env_pkg.sv

top:
	vlog $(DV_DIR)/tb/top.sv

test:
	vlog $(DV_DIR)/test/test_pkg.sv

sim:
	#vopt -novopt top -o top_opt
	vsim -c work.top -do "run -a; q" +UVM_TESTNAME=basic_read_write_test

sim_waves:
	#vopt -novopt top -o top_opt
	vsim -voptargs="+acc" work.top +UVM_TESTNAME=basic_read_write_test

clean:
	rm -rf transcript vsim.wlf work
