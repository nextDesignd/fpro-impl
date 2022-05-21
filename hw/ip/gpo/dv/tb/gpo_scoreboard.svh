
class gpo_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(gpo_scoreboard);

    function new(string name="gpo_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // TODO: connect sbd to montior
    endfunction

endclass
