//`default_nettype none
module uart
    (
        // APB
        input  logic         pclk,
        input  logic         presetn,
        input  logic         psel,
        input  logic         penable,
        input  logic [11:0]  paddr,
        input  logic         pwrite,
        input  logic [31:0]  pwdata,
        output logic [31:0]  prdata,
        output logic         pready,
        output logic         pslverr
    );

    // ------------ REGISTERS ------------
    // UARTDR
    logic         uartdr_fifo_wr;
    logic [7:0]   uartdr_data_out;
    logic         uartdr_fifo_rd;
    logic [11:0]  uartdr_data_in;

    // UARTFR
    logic          uartfr_cts;
    logic          uartfr_dsr;
    logic          uartfr_dcd;
    logic          uartfr_busy;
    logic          uartfr_rxfe;
    logic          uartfr_txfe;
    logic          uartfr_rxff;
    logic          uartfr_txff;
    logic          uartfr_ri;

    // UARTLCR_H
    logic         uartlcr_h_brk;
    logic         uartlcr_h_pen;
    logic         uartlcr_h_eps;
    logic         uartlcr_h_stp2;
    logic         uartlcr_h_fen;
    logic [1:0]   uartlcr_h_wlen;
    logic         uartlcr_h_sps;

    // UARTCR
    logic         uartcr_uarten;
    logic         uartcr_siren;
    logic         uartcr_sirlp;
    logic         uartcr_lbe;
    logic         uartcr_txe;
    logic         uartcr_rxe;
    logic         uartcr_dtr;
    logic         uartcr_rts;
    logic         uartcr_out1;
    logic         uartcr_out2;
    logic         uartcr_rtsen;
    logic         uartcr_ctsen;

    uart_regs regs(
        .*
    );
    // xxxxxxxxxxxx REGISTERS xxxxxxxxxxxx

endmodule
