module fetch #(parameter N = 64) (
    input logic[N-1: 0] PCBranch_F, PC_TrapTrigger, PC_TrapReturn,
    input logic interruptSignal, trapReturn,
    input logic PCSrc_F, clk, reset, PC_enable,
    output logic[N-1: 0] imem_addr_F
);
    logic[N-1: 0] PC_out, branchMux, trapEntryMux, trapReturnMux;
    logic[N-1: 0] PC_4, PC_cmp;
    flopre #(N) PC(.clk(clk), 
                  .reset(reset), 
                  .d(trapEntryMux),
                  .enable(PC_enable),
                  .q(PC_out));

    assign PC_4 = PC_out + 'd4;
    assign branchMux = PCSrc_F ? PCBranch_F : PC_4;
    // Exceptions take precedence
    assign trapEntryMux = interruptSignal ? PC_TrapTrigger : trapReturnMux;
    assign trapReturnMux = trapReturn ? PC_TrapReturn : branchMux;
    assign imem_addr_F = PC_out;
    
endmodule