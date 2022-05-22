module gpi 
   #(
        parameter WIDTH = 8  // width of Output port
    )
    (
        // APB
        input          pclk,
        input          presetn,
        input          psel,
        input          penable,
        input  [5:0]   paddr,
        input          pwrite,
        input  [31:0]  pwdata,
        output [31:0]  prdata,
        output         pready,
        output         pslverr,

        // Inputs
        input [WIDTH-1:0] in
    );

    logic [31:0] in_buf;

    always @(posedge pclk)
        if(!presetn)
            in_buf <= '0;
        else
            in_buf <= in;

    assign pready  = 1;
    assign pslverr = (paddr != 0) && psel && penable;
    assign prdata  = in_buf;

endmodule
