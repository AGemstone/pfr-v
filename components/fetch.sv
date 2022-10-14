module fetch #(parameter N = 64) (
    input logic[N-1: 0] PCBranch_F,
    input logic PCSrc_F, clk, reset,
    output logic[N-1: 0] imem_addr_F//, PC_4
);
    logic[N-1: 0] PC_out, mux_out;
    
    flopr #(N) PC(.clk(clk), 
                  .reset(reset), 
                  .d(mux_out), 
                  .q(PC_out));

    logic[N-1: 0] PC_4;
    assign PC_4 = PC_out + 'd4;
    assign mux_out = PCSrc_F ? PCBranch_F : PC_4;
    assign imem_addr_F = PC_out;
    
endmodule