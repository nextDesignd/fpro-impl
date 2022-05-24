
class gpi_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(gpi_scoreboard);

    localparam int unsigned PORT_WIDTH = 8;
    virtual gpi_if vif;

    logic [31:0] in_buf;

    uvm_analysis_imp #(apb_txn, gpi_scoreboard) apb_imp;

    function new(string name="gpi_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        apb_imp = new("apb_imp", this);

        if(!uvm_config_db#(virtual gpi_if)::get(this, "", "gpi_if", vif))
            `uvm_fatal("TEST_BASE", "Unable to get gpi_if")

        if(vif == null)
            `uvm_fatal("TEST_BASE", "Null vif");
    endfunction

    function void write(apb_txn txn);
        apb_txn clone;
        $cast(clone, txn.clone());

        // TODO: enable this
        // fork 
        //     begin
        //         #1;
        //         if(!clone.is_write) begin
        //             if(in_buf[PORT_WIDTH-1:0] !== txn.data[PORT_WIDTH-1:0])
        //                 `uvm_error("GPO_SCOREBOARD", {
        //                     "Out mismatch ", 
        //                     $psprintf("Exp: %h ", txn.data[PORT_WIDTH-1:0]),
        //                     $psprintf("Act: %h" , in_buf[PORT_WIDTH-1:0])
        //                 })
        //         end
        //     end
        // join_none
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            in_buf <= vif.in[PORT_WIDTH-1:0];
        end
    endtask

endclass
