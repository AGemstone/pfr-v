module except_controller #(parameter N = 64) 
                         (input logic[N-1:0] PC_F,
                          input logic MIE, async, clk, reset,
                          input logic[2:0] breakSrc,
                          input logic[15:0] exceptSignal,
                          input logic[15:0] interruptSignal,
                          input logic[1:0] privMode,
                          output logic[1:0] nextPriv,
                          output logic mIEToggle,
                          output logic[N-1:0] PC_Trap);
    
    // CSR signals should output into decode stage

    logic[5:0] exceptCode, interruptCode;
    logic [N-1:0] mcauseCode;
    
    
    // Only support for software breakpoints for now
    exceptDecode eCode(.signal(exceptSignal),
                       .breakSrc(breakSrc),
                       .code(exceptCode));
    
    interruptDecode iCode(.signal(interruptSignal),
                          .code(interruptCode));

    // read only for now
    logic[N-1:0] mtvecOut;
    logic[N-1:0] mcause;
    logic[N-1:0] mepc;
    logic exceptCSREnable;
    
    flopre #(64) mcause_csr (.clk(clk),  
                             .reset(reset), 
                             .enable(exceptCSREnable),
                             .d(mcauseCode),
                             .q(mcause_csr));

    flopre #(64) mepc_csr (.clk(clk),  
                           .reset(reset), 
                           .enable(exceptCSREnable),
                           .d(PC_F),
                           .q(mepc));

    // in the future we want to be able to change the mode and address
    // flopre_init #(64,{N{1'b0}}) mtvec (
    // .clk(clk), 
    // .reset(reset),
    // .enable(),
    // .d(), 
    // .q(PC_Trap));

    assign exceptCSREnable = MIE & (|{exceptSignal});
    // no async interrupts for now :(
    assign mtvecOut = 'h0000000000001000;
    assign PC_Trap = {{mtvecOut[N-1:2]}, {2'b0}};
    assign mcauseCode[5:0] = async ? interruptCode : exceptCode;
    assign mcauseCode[N-2:6] = 'b0;
    assign mcauseCode[N-1] = async;


endmodule