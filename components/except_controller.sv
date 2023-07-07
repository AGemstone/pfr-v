module except_controller #(parameter N = 64) 
                         (input logic MIE, async, clk, reset,
                          input logic[2:0] breakSrc,
                          input logic[15:0] exceptSignal,
                          input logic[15:0] interruptSignal,
                          input logic[N-1:0] PC_F,
                          input logic[N-1:0] CSR_In,
                          input logic[11:0] CSR_addr,
                          input logic CSR_WriteEnable,
                          output logic[15:0] trapTrigger,
                          output logic[N-1:0] mcause,
                          output logic[N-1:0] mtvec,
                          output logic[N-1:0] mepc);
    
    
     
    // CSR mask
    localparam logic[N-1:0] mie_mask = {{52'b0}, {4'b1000}, {4'b1000}, {4'b1000}};
    localparam logic[N-1:0] mtvec_mask = {{40'b0}, {22'h3fffff}, {2'b0}};

    logic[5:0] exceptCode, interruptCode;
    logic [N-1:0] mcauseCode;
    logic [N-1:0] mepcWrite;
    
    
    
    // Only support for software breakpoints for now
    exceptDecode eCode(.signal(exceptSignal),
                       .breakSrc(breakSrc),
                       .code(exceptCode));
    
    interruptDecode iCode(.signal(interruptSignal),
                          .code(interruptCode));

    // Internal CSR signals
    logic exceptCSREnable;
    logic[N-1:0] mtvecOut;

    flopre #(64) mcause_csr (.clk(clk),  
                             .reset(reset), 
                             .enable(exceptCSREnable),
                             .d(mcauseCode),
                             .q(mcause));

    // when pipelining source should depend on where the signal is coming from
    // earlier in pipeline has more priority
    /*
        if exceptSignal from fetch
            mepcIn = PC_f
        else if exceptSignal from decode
            mepcIn = PC_f
        ...
    */
    assign mepcWrite = exceptCSREnable ?
                       PC_F: 
                       ((CSR_addr == 'h341) && CSR_WriteEnable ? CSR_In : '0);
    flopre #(64) mepc_csr (.clk(clk),  
                          .reset(reset),
                        //   .enable(exceptCSREnable | ((CSR_addr == 'h341) && CSR_WriteEnable)),
                          .enable(exceptCSREnable),
                          .d(PC_F),
                          .q(mepc));
    
    flopre #(64) mtvec_csr (.clk(clk), 
                            .reset(reset),
                            .enable((CSR_addr == 'h305) && CSR_WriteEnable),
                            .d((mtvec & ~mtvec_mask) | (CSR_In & mtvec_mask)),
                            .q(mtvec));

    assign exceptCSREnable = MIE & (|{exceptSignal});
    // no async interrupts for now 
    assign mcauseCode[5:0] = async ? interruptCode : exceptCode;
    assign mcauseCode[N-2:6] = 'b0;
    assign mcauseCode[N-1] = async;
    assign trapTrigger = {16{MIE}} & exceptSignal;

endmodule