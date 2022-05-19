
class apb_txn extends uvm_sequence_item;
    `uvm_object_utils(apb_txn);

    bit [31:0] addr;
    bit        is_write;
    bit [31:0] data;
    bit        slverr;

    function new(string name="apb_txn");
        super.new(name);
    endfunction

endclass
