
class uart_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(uart_scoreboard);

    function new(string name="uart_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

endclass
