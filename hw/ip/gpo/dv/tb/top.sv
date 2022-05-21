module top;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import test_pkg::*;

    bit         clk;
    bit         resetn;

    apb_if apb_master_if();

    assign apb_master_if.prdata = 0;
    assign apb_master_if.pready = 1;
    assign apb_master_if.pslverr = 0;

    assign apb_master_if.pclk = clk;
    assign apb_master_if.presetn = resetn;

    initial begin
        uvm_config_db#(virtual apb_if)::set(
            uvm_top, 
            "*", 
            "apb_master_if", 
            apb_master_if
       );

       run_test();
    end

    initial begin
        resetn = 1'b0;
        repeat(20) @(posedge clk);
        #1;
        resetn = 1'b1;
    end

    initial begin
        clk = 1'b0;
        forever
        #10 clk = ~clk;
    end

endmodule
