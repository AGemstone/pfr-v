module fetch #(parameter N = 64) (
    input logic[N-1: 0] PCBranch_F,
    input logic PCSrc_F, clk, reset,
    output logic[N-1: 0] imem_addr_F
);
    logic[N-1: 0] PC_out, add4_out, mux_out;
    
    adder #(N) add4 (.a('d4), 
                     .b(PC_out), 
                     .y(add4_out));

    mux2 #(N) mux (.s(PCSrc_F),
                   .d0(add4_out),
                   .d1(PCBranch_F),
                   .y(mux_out));

    flopr #(N) PC(.clk(clk), 
                  .reset(reset), 
                  .d(mux_out), 
                  .q(PC_out));

    assign imem_addr_F = PC_out;
    
endmodule