
class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent);

    apb_master_driver driver;
    apb_monitor monitor;
    apb_sequencer sequencer;

    virtual apb_if vif;

    function new(string name="apb_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        driver = apb_master_driver::type_id::create("driver", this);
        driver.vif = vif;

        sequencer = apb_sequencer::type_id::create("sequencer", this);

        monitor = apb_monitor::type_id::create("monitor", this);
        monitor.vif = vif;

    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction


endclass

