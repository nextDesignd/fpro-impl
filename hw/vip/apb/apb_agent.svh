
class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent);

    apb_master_driver driver;
    virtual apb_if vif;

    function new(string name="apb_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        driver = apb_master_driver::type_id::create("driver", this);
        driver.vif = vif;

    endfunction

endclass

