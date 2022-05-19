
class env extends uvm_env;

    `uvm_component_utils(env);

    apb_agent master;

    virtual apb_if vif;

    function new(string name="env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        master = apb_agent::type_id::create("master", this);
        master.vif = vif;

    endfunction

endclass
