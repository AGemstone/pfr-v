module memoryStall #(parameter N = 64) (
    input logic memOp, clk, reset,
    input logic[N-1:0] dataReadDM,
    output logic PC_enable
);

    // logic[N-1:0] dataRead;
    // logic[1:0] counter, counterSub;
    // logic cmp, counterEnable, counterStart;
    
    // flopre #(2) counterReg(.clk(clk),
    //                        .reset(reset),
    //                        .d(counter),
    //                        .q(counterSub),
    //                        .enable(counterEnable));

    // always_comb begin
    //     if (memOp & (counter == 2'b0) & (~counterStart))
    //         counterStart = 1'b1;
    //     else
    //         counterStart = 'b0; 
    // end

    // assign counter = ~(&{counter}) ? 2'b0: counterSub - 2'b1;
    // assign PC_enable = ~(&{counter});
    assign PC_enable = 1;

endmodule