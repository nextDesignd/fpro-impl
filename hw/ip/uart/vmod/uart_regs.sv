//`default_nettype none
module uart_regs
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
        output logic         pslverr,

        // UARTDR
        output logic         uartdr_fifo_wr,
        output logic [7:0]   uartdr_data_out,
        output logic         uartdr_fifo_rd,
        input  logic [11:0]  uartdr_data_in,

        // UARTFR
        input logic          uartfr_cts,
        input logic          uartfr_dsr,
        input logic          uartfr_dcd,
        input logic          uartfr_busy,
        input logic          uartfr_rxfe,
        input logic          uartfr_txfe,
        input logic          uartfr_rxff,
        input logic          uartfr_txff,
        input logic          uartfr_ri,

        // UARTLCR_H
        output logic         uartlcr_h_brk,
        output logic         uartlcr_h_pen,
        output logic         uartlcr_h_eps,
        output logic         uartlcr_h_stp2,
        output logic         uartlcr_h_fen,
        output logic [1:0]   uartlcr_h_wlen,
        output logic         uartlcr_h_sps,

        // UARTCR
        output logic         uartcr_uarten,
        output logic         uartcr_siren,
        output logic         uartcr_sirlp,
        output logic         uartcr_lbe,
        output logic         uartcr_txe,
        output logic         uartcr_rxe,
        output logic         uartcr_dtr,
        output logic         uartcr_rts,
        output logic         uartcr_out1,
        output logic         uartcr_out2,
        output logic         uartcr_rtsen,
        output logic         uartcr_ctsen

    );

    // Implemented registers ->
    // UARTDR
    // UARTRSR
    // UARTFR
    // UARTLCR_H
    // UARTCR
    // UARTIFLS
    // UARTMSC
    // UARTRIS
    // UARTMIS
    // UARTICR
    // UARTDMACR

    `define UARTDR_OFFSET 12'h0
    `define UARTRSR_OFFSET 12'h4
    `define UARTFR_OFFSET 12'h18
    `define UARTLCR_H_OFFSET 12'h2c
    `define UARTCR_OFFSET 12'h30
    `define UARTIFLS_OFFSET 12'h34
    `define UARTMSC_OFFSET 12'h38
    `define UARTRIS_OFFSET 12'h3c
    `define UARTMIS_OFFSET 12'h40
    `define UARTICR_OFFSET 12'h44
    `define UARTDMACR_OFFSET 12'h48

    logic  request_valid;

    assign request_valid  = psel && penable & pready;
    assign pready = 1;

    // UARTDR
    assign uartdr_fifo_wr = request_valid && pwrite && (paddr == `UARTDR_OFFSET);
    assign uartdr_fifo_rd = request_valid && !pwrite && (paddr == `UARTDR_OFFSET);
    assign uartdr_data_out = pwdata[7:0];

    // UARTRSR (TODO)

    // UARTFR
    logic  uartfr_rd, uartfr_wr;
    assign uartfr_rd = request_valid && !pwrite && (paddr == `UARTFR_OFFSET);
    assign uartfr_wr = request_valid && pwrite  && (paddr == `UARTFR_OFFSET);

    // UARTLCR_H
    logic uartlcr_h_rd, uartlcr_h_wr;
    assign uartlcr_h_rd = request_valid && !pwrite && (paddr == `UARTLCR_H_OFFSET);
    assign uartlcr_h_wr = request_valid && pwrite  && (paddr == `UARTLCR_H_OFFSET);
    always @(posedge pclk) begin
        if(!presetn) begin
            uartlcr_h_brk   <= '0;
            uartlcr_h_pen   <= '0;
            uartlcr_h_eps   <= '0;
            uartlcr_h_stp2  <= '0;
            uartlcr_h_fen   <= '0;
            uartlcr_h_wlen  <= '0;
            uartlcr_h_sps   <= '0;
        end else if(uartlcr_h_wr) begin
            uartlcr_h_brk   <= pwdata[0];
            uartlcr_h_pen   <= pwdata[1];
            uartlcr_h_eps   <= pwdata[2];
            uartlcr_h_stp2  <= pwdata[3];
            uartlcr_h_fen   <= pwdata[4];
            uartlcr_h_wlen  <= pwdata[6:5];
            uartlcr_h_sps   <= pwdata[7];
        end
    end

    // UARTCR
    logic uartcr_rd, uartcr_wr;
    assign uartcr_rd = request_valid && !pwrite && (paddr == `UARTCR_OFFSET);
    assign uartcr_wr = request_valid && pwrite  && (paddr == `UARTCR_OFFSET);
    always @(posedge pclk) begin
        if(!presetn) begin
            uartcr_uarten  <= '0;
            uartcr_siren   <= '0;
            uartcr_sirlp   <= '0;
            uartcr_lbe     <= '0;
            uartcr_txe     <= 1'b1;
            uartcr_rxe     <= 1'b1;
            uartcr_dtr     <= '0;
            uartcr_rts     <= '0;
            uartcr_out1    <= '0;
            uartcr_out2    <= '0;
            uartcr_rtsen   <= '0;
            uartcr_ctsen    <= '0;
        end else if(uartcr_wr) begin
            uartcr_uarten  <= pwdata[0];
            uartcr_siren   <= pwdata[1];
            uartcr_sirlp   <= pwdata[2];
            uartcr_lbe     <= pwdata[7];
            uartcr_txe     <= pwdata[8];
            uartcr_rxe     <= pwdata[9];
            uartcr_dtr     <= pwdata[10];
            uartcr_rts     <= pwdata[11];
            uartcr_out1    <= pwdata[12];
            uartcr_out2    <= pwdata[13];
            uartcr_rtsen   <= pwdata[14];
            uartcr_ctsen    <= pwdata[15];
        end
    end
    
    always @* begin
        pslverr = 0;
        prdata  = 0;
        case(1)
            uartdr_fifo_rd: prdata = uartdr_data_in;
            uartfr_rd     : prdata = {23'h0,
                                      uartfr_ri,
                                      uartfr_txff,
                                      uartfr_rxff,
                                      uartfr_txfe,
                                      uartfr_rxfe,
                                      uartfr_busy,
                                      uartfr_dcd,
                                      uartfr_dsr,
                                      uartfr_cts};
            uartfr_wr     : pslverr = 1;
            uartlcr_h_rd  : prdata  = {24'h0,
                                       uartlcr_h_sps,
                                       uartlcr_h_wlen,
                                       uartlcr_h_fen,
                                       uartlcr_h_stp2,
                                       uartlcr_h_eps,
                                       uartlcr_h_pen,
                                       uartlcr_h_brk};
            uartcr_rd      : prdata = {17'h0,
                                       uartcr_ctsen,
                                       uartcr_rtsen,
                                       uartcr_out2,
                                       uartcr_out1,
                                       uartcr_rts,
                                       uartcr_dtr,
                                       uartcr_rxe,
                                       uartcr_txe,
                                       uartcr_lbe,
                                       4'b0000,
                                       uartcr_sirlp,
                                       uartcr_siren,
                                       uartcr_uarten};
        endcase
    end

endmodule
