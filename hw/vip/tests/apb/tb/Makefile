
# Compile APB
# Compile env
# Compile test
# Compile top

# Expects FPRO_DIR to be defined

VIP_DIR=$(FPRO_DIR)/hw/vip

TEST_DIR=$(VIP_DIR)/tests

all: apb tb

apb: 
	echo $(VIP_DIR)
	vlog $(VIP_DIR)/apb/apb_pkg.sv

tb:
	vlog $(TEST_DIR)/apb/tb/env_pkg.sv \
		 $(TEST_DIR)/apb/tb/test_pkg.sv \
		 $(TEST_DIR)/apb/tb/top.sv 

sim:
	vsim -c work.top -do "run -a; q" +UVM_TESTNAME=basic_read_write_test
