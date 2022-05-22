
class basic_read_write_seq extends apb_base_seq;
    `uvm_object_utils(basic_read_write_seq);

    localparam PORT_WIDTH = 8;

    enum bit [31:0] {
        DATA_REG = 32'h0
    } GPI_REG_OFFSET;

    task body();

        // b2b transfer, without delay
        repeat(20) begin
            bit [31:0] rdata;

            read32(DATA_REG,  rdata);
        end

        // b2b transfer, with delay
        repeat(20) begin
            bit [31:0] rdata;
            int unsigned delay;

            delay = $urandom_range(0, 100);
            #(delay);

            read32(DATA_REG,  rdata);
        end
    endtask

endclass


