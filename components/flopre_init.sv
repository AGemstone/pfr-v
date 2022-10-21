module flopre_init #(parameter N = 64, RESET_VAL = {N{1'b0}}) (
    input logic clk, reset, enable,
    input logic[N-1:0] d, 
    output logic[N-1:0] q
);

always_ff @(posedge clk, posedge reset)
    if(reset) 
        q <= RESET_VAL;
    else if (enable) 
        q <= d;
    
    
endmodule