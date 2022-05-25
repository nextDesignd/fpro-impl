module uart
    (
        // APB
        input          pclk,
        input          presetn,
        input          psel,
        input          penable,
        input  [11:0]  paddr,
        input          pwrite,
        input  [31:0]  pwdata,
        output [31:0]  prdata,
        output         pready,
        output         pslverr,
    );
    
    uart_regs regs(
        .pclk      (pclk   ),
        .presetn   (presetn),
        .psel      (psel   ),
        .penable   (penable),
        .paddr     (paddr  ),
        .pwrite    (pwrite ),
        .pwdata    (pwdata ),
        .prdata    (prdata ),
        .pready    (pready ),
        .pslverr   (pslverr)
    );

endmodule
