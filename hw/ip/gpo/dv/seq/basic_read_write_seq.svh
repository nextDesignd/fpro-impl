
class basic_read_write_seq extends apb_base_seq;
    `uvm_object_utils(basic_read_write_seq);

    localparam PORT_WIDTH = 8;

    enum bit [31:0] {
        DATA_REG = 32'h0
    } GPO_REG_OFFSET;

    task body();

        // b2b transfer, without delay
        repeat(20) begin
            bit [31:0] rdata, wdata;

            wdata = $urandom_range(0, (32'h1 << PORT_WIDTH));

            write32(DATA_REG, wdata);
            read32(DATA_REG,  rdata);
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
            write32(DATA_REG, wdata);
            #(delay);
            read32(DATA_REG,  rdata);
            if( wdata != rdata ) 
                `uvm_error("DATA_MISMATCH", {
                    "wdata != rdata ",
                    $psprintf("wdata = %h ", wdata),
                    $psprintf("rdata = %h", rdata)
                })

        end
    endtask

endclass


