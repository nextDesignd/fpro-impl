
class basic_read_write_seq extends apb_base_seq;
    `uvm_object_utils(basic_read_write_seq);

    task body();
        bit [31:0] data;

        write32('h1, 'h20);
        read32('h1, data);
        `uvm_info("BASIC_READ_WRITE_SEQ", $psprintf("data = %h", data), UVM_MEDIUM);

        write32('h2, 'h22);
        #1;
        read32('h2, data);
        #5;
        read32('h2, data);
        #54;
        read32('h2, data);
        `uvm_info("BASIC_READ_WRITE_SEQ", $psprintf("data = %h", data), UVM_MEDIUM);

    endtask

endclass
