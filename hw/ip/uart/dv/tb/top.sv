module top;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import test_pkg::*;

    bit         clk;
    bit         resetn;

    apb_if apb_master_if();

    uart dut(
        .pclk(clk),
        .presetn(resetn),
        .psel(apb_master_if.psel),
        .penable(apb_master_if.penable),
        .paddr(apb_master_if.paddr),
        .pwrite(apb_master_if.pwrite),
        .pwdata(apb_master_if.pwdata),
        .prdata(apb_master_if.prdata),
        .pready(apb_master_if.pready),
        .pslverr(apb_master_if.pslverr)
    );

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
