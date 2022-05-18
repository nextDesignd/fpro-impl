
class apb_master_driver extends uvm_driver #(apb_txn);

    `uvm_component_utils(apb_master_driver);

    virtual apb_if vif;

    function new(string name="apb_master_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            reset_deasserted();
            fork begin
                fork
                    drive_transfers();
                    monitor_reset();
                join_any
                disable fork;
            join end
        end
    endtask

    task reset_deasserted();
        wait(vif.presetn === 1'b1);
    endtask

    task drive_transfers();
        forever begin
            apb_txn txn;
            seq_item_port.get_next_item(txn);


        end
    endtask

    task monitor_reset();
        @(negedge vif.presetn);
    endtask

endclass

