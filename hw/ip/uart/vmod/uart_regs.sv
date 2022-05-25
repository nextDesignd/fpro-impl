module uart_regs
    (
        // APB
        input          pclk,
        input          presetn,
        input          psel,
        input          penable,
        input  [11:0]  paddr,
        input          pwrite,
        input  [31:0]  pwdata,
        output [31:0]  prdata,
        output         pready,
        output         pslverr,
    );

    logic [31:0] uartdr;
    logic [31:0] uartrsr;
    logic [31:0] uartfr;
    // uartilpr
    // uartibrd
    // uartfbrd
    logic [31:0] uartlcr_h;
    logic [31:0] uartcr;
    logic [31:0] uartifls;
    logic [31:0] uartimsc;
    logic [31:0] uartris;
    logic [31:0] uartmis;
    logic [31:0] uarticr;
    logic [31:0] uartdmacr;

endmodule
