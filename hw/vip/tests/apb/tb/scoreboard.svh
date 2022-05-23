
class test_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(test_scoreboard);

    uvm_analysis_imp #(apb_txn, test_scoreboard) master_monitor_imp;

    apb_txn txnq[$];

    function new(string name="test_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        master_monitor_imp = new("master_monitor_imp", this);
    endfunction

    function void write(apb_txn txn);
        apb_txn clone;
        $cast(clone, txn.clone());
        txnq.push_back(clone);
    endfunction

endclass
