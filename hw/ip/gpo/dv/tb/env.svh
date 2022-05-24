
class env extends uvm_env;

    `uvm_component_utils(env);

    apb_agent master;
    gpo_scoreboard sbd;

    virtual apb_if vif;

    function new(string name="env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        master = apb_agent::type_id::create("master", this);
        master.vif = vif;

        sbd = gpo_scoreboard::type_id::create("gpo_scoreboard", this);

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        master.monitor.apb_monitor_port.connect(sbd.apb_imp);
    endfunction

endclass
