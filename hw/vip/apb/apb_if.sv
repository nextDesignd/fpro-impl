interface apb_if();
    logic         pclk;
    logic         presetn;

    logic         psel;
    logic         penable;
    logic [31:0]   paddr;
    logic         pwrite;
    logic [31:0]  pwdata;

    logic [31:0]  prdata;
    logic         pready;
    logic         pslverr;
endinterface
