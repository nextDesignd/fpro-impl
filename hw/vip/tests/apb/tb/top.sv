module top;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import test_pkg::*;



    apb_if apb_master_if();

    assign apb_master_if.prdata = 0;
    assign apb_master_if.pready = 1;
    assign apb_master_if.pslverr = 0;

    initial begin
        uvm_config_db#(virtual apb_if)::set(
            uvm_top, 
            "*", 
            "apb_master_if", 
            apb_master_if
       );

       run_test();
    end

endmodule
