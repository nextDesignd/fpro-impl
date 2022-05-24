
class gpo_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(gpo_scoreboard);

    localparam int unsigned PORT_WIDTH = 8;
    virtual gpo_if vif;

    uvm_analysis_imp #(apb_txn, gpo_scoreboard) apb_imp;

    function new(string name="gpo_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        apb_imp = new("apb_imp", this);

        if(!uvm_config_db#(virtual gpo_if)::get(this, "", "gpo_if", vif))
            `uvm_fatal("TEST_BASE", "Unable to get gpo_if")

        if(vif == null)
            `uvm_fatal("TEST_BASE", "Null vif");
    endfunction

    function void write(apb_txn txn);
        apb_txn clone;
        $cast(clone, txn.clone());

        fork 
            begin
                #1;
                if(clone.is_write) begin
                    if(vif.out[PORT_WIDTH-1:0] !== txn.data[PORT_WIDTH-1:0])
                        `uvm_error("GPO_SCOREBOARD", {
                            "Out mismatch ", 
                            $psprintf("Exp: %h ", txn.data[PORT_WIDTH-1:0]),
                            $psprintf("Act: %h" , vif.out[PORT_WIDTH-1:0])
                        })
                end
            end
        join_none
    endfunction

endclass
