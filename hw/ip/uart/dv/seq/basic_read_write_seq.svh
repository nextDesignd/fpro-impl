
class basic_read_write_seq extends apb_base_seq;
    `uvm_object_utils(basic_read_write_seq);

    localparam PORT_WIDTH = 8;

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

    enum bit [31:0] {
        UARTCR = `UARTCR_OFFSET
    } UART_REG_OFFSET;

    task body();

        // b2b transfer, without delay
        repeat(20) begin
            bit [31:0] rdata, wdata;

            wdata = $urandom_range(0, (32'h1 << PORT_WIDTH));

            write32(UARTCR, wdata);
            read32(UARTCR,  rdata);
            wdata = wdata & 32'h0000_7F87;
            if( wdata != rdata ) 
                `uvm_error("DATA_MISMATCH", {
                    "wdata != rdata ",
                    $psprintf("wdata = %h ", wdata),
                    $psprintf("rdata = %h", rdata)
                })

        end

        // b2b transfer, with delay
        repeat(20) begin
            bit [31:0] rdata, wdata;
            int unsigned delay;

            wdata = $urandom_range(0, (32'h1 << PORT_WIDTH));
            delay = $urandom_range(0, 100);

            #(delay);
            write32(UARTCR, wdata);
            #(delay);
            read32(UARTCR,  rdata);
            wdata = wdata & 32'h0000_7F87;
            if( wdata != rdata ) 
                `uvm_error("DATA_MISMATCH", {
                    "wdata != rdata ",
                    $psprintf("wdata = %h ", wdata),
                    $psprintf("rdata = %h", rdata)
                })

        end
    endtask

endclass

