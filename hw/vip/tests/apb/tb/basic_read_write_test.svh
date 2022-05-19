
class basic_read_write_test extends test_base;
    `uvm_component_utils(basic_read_write_test);

    function new(string name="basic_read_write_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        begin
            basic_read_write_seq seq = basic_read_write_seq::type_id::create("seq");
            seq.start(env_instance.master.sequencer);
        end
        phase.drop_objection(this);
    endtask

endclass
