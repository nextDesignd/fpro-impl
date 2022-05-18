package apb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "apb_txn.svh"
    `include "apb_slave_driver.svh"
    `include "apb_master_driver.svh"
    `include "apb_monitor.svh"
    `include "apb_agent.svh"

endpackage

`include "apb_if.sv"
