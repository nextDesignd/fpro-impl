
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

`define  ASSERT(item, act, expt) \
    if(act != expt) \
        `uvm_error("BASIC_READ_WRITE_TEST", \
            $psprintf("apb[%0d] %s mismatch, expt: %h act: %h", i, item, expt, act));
        
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        // This part would require update passed on what stimulus is passsed
        //

        `define TXNQ env_instance.sbd.txnq

        // TODO : find if there is a way to get a handle here, intead of using define
        // apb_txn txnq[$] = env_instance.sbd.txnq;

        if(`TXNQ.size() != 6)
            `uvm_error("BASIC_READ_WRITE_TEST", 
                $psprintf("Expected 6 transfers, actual = %d", `TXNQ.size()));

        
        foreach(`TXNQ[i]) begin
            case(i)
                0: begin
                    `ASSERT("addr", `TXNQ[i].addr, 1)
                    `ASSERT("is_write", `TXNQ[i].is_write, 1)
                    `ASSERT("data", `TXNQ[i].data, 'h20)
                end
                1: begin
                    `ASSERT("addr", `TXNQ[i].addr, 1)
                    `ASSERT("is_write", `TXNQ[i].is_write, 0)
                    // TODO : enable check of read data, randomise data on top
                    //`ASSERT("data", `TXNQ[i].data, 'h20)
                end
                2: begin
                    `ASSERT("addr", `TXNQ[i].addr, 2)
                    `ASSERT("is_write", `TXNQ[i].is_write, 1)
                    `ASSERT("data", `TXNQ[i].data, 'h22)
                end
                3,4,5: begin
                    `ASSERT("addr", `TXNQ[i].addr, 2)
                    `ASSERT("is_write", `TXNQ[i].is_write, 0)
                    // TODO : enable check of read data, randomise data on top
                    //`ASSERT("data", `TXNQ[i].data, 'h20)
                end

            endcase
            `ASSERT("slverr", `TXNQ[i].slverr, 0)
        end
    endfunction

endclass
