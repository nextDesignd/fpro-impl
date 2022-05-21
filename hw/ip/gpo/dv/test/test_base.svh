
class test_base extends uvm_test;

    `uvm_component_utils(test_base);

    env env_instance;
    virtual apb_if vif;

    function new(string name="test_base", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env_instance = env::type_id::create("env_instance", this);
        uvm_config_db#(virtual apb_if)::get(this, "", "apb_master_if", vif);
        if(vif == null)
            `uvm_fatal("TEST_BASE", "Unable to get apb_master_if")
        env_instance.vif = vif;

    endfunction

    task run_phase(uvm_phase phase);
        
        phase.raise_objection(this);

        `uvm_info("TEST_BASE", {
            "This is a base test, normally it would be extended by some ",
            "functional test overriding this run-phase"
            }, UVM_MEDIUM)

        #1000;


        phase.drop_objection(this);

    endtask

endclass
