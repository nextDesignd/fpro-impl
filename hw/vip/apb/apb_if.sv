interface apb_if;
    wire         pclk;
    wire         presetn;
    wire         psel;
    wire         penable;
    wire [5:0]   paddr;
    wire         pwrite;
    wire [31:0]  pwdata;
    wire [31:0]  prdata;
    wire         pready;
    wire         pslverr;
endinterface
