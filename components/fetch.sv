module fetch #(parameter N = 64) (
    input logic[N-1: 0] PCBranch_F, PC_Trap,
    input logic interruptSignal,
    input logic PCSrc_F, clk, reset,
    output logic[N-1: 0] imem_addr_F
);
    logic[N-1: 0] PC_out, branchMux, interruptMux;
    
    flopr #(N) PC(.clk(clk), 
                  .reset(reset), 
                  .d(interruptMux), 
                  .q(PC_out));

    logic[N-1: 0] PC_4;
    assign PC_4 = PC_out + 'd4;
    assign branchMux = PCSrc_F ? PCBranch_F : PC_4;
    assign interruptMux = interruptSignal ? PC_Trap : branchMux; 
    assign imem_addr_F = PC_out;
    
endmodule