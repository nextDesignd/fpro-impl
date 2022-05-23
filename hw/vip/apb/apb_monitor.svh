
class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor);

    virtual apb_if vif;

    uvm_analysis_port #(apb_txn) apb_monitor_port;

    function new(string name="apb_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(vif == null)
            `uvm_fatal("APB_MONITOR", "Invalid vif passed")

        apb_monitor_port = new("apb_monitor_port", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            reset_deasserted();
            fork begin
                fork
                    monitor_transfers();
                    monitor_reset();
                join_any
                disable fork;
            end join
        end
    endtask

    task reset_deasserted();
        wait(vif.presetn === 1'b1);
    endtask

    task monitor_transfers();
        forever begin
            apb_txn txn = apb_txn::type_id::create("apb_txn");

            @(posedge vif.pclk)
            while(!vif.psel) @(posedge vif.pclk);

            txn.addr = vif.paddr;
            txn.is_write = vif.pwrite;

            @(posedge vif.pclk)
            while(!vif.pready) @(posedge vif.pclk);

            if(txn.is_write) txn.data = vif.pwdata;
            else             txn.data = vif.prdata;
            txn.slverr = vif.pslverr;

            apb_monitor_port.write(txn);
        end
        //bit wait_for_edge = 1'b1;
        //forever begin
        //    apb_txn txn;
        //    seq_item_port.get_next_item(txn);
        //    if(wait_for_edge) @(posedge vif.pclk);
        //    vif.psel <= 1'b1;
        //    vif.pwrite <= txn.is_write;
        //    vif.paddr <= txn.addr;
        //    if(txn.is_write) vif.pwdata <= txn.data;
        //    @(posedge vif.pclk);
        //    vif.penable <= 1'b1;

        //    forever
        //        @(posedge vif.pclk)
        //        if(vif.pready) break;

        //    txn.slverr = vif.pslverr;
        //    if(!vif.pwrite) txn.data = vif.prdata;
        //    vif.penable <= 1'b0;

        //    // TODO : This appears as a zero-time glitch on psel, fix it
        //    vif.psel    <= 1'b0;

        //    seq_item_port.item_done();

        //    // ensure b2b transfers
        //    if(wait_for_edge) begin
        //        wait_for_edge = 1'b0;
        //        fork
        //            #1 wait_for_edge = 1'b1;
        //        join_none
        //    end
        //end
    endtask

    task monitor_reset();
        @(negedge vif.presetn);
    endtask

endclass
