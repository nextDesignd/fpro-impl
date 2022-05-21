module gpo 
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

        // Outputs
        output [WIDTH-1:0] out
    );

    logic [31:0] out_buf;

    wire wr_out_en;

    assign wr_out_en = (paddr === 0) && psel && pwrite && penable;

    always @(posedge pclk)
        if(!presetn)
            out_buf <= '0;
        else if(wr_out_en)
            out_buf <= pwdata;

    assign pready  = 1;
    assign pslverr = (paddr != 0) && psel && penable;
    assign prdata  = out_buf;

    assign out = out_buf[WIDTH-1:0];

endmodule
