module core #(parameter N = 64)
            (input logic clk, reset,
            input logic[N-1:0] DM_readData,
            output logic [N-1:0] DM_writeData, DM_addr,
            output logic DM_writeEnable, DM_readEnable,
            input logic [14:0] coprocessorIOAddr,
            input logic [4:0] coprocessorIOControl,
            input logic [N-1:0] coprocessorIODataOut,
            output logic [N-1:0] coprocessorIODataIn,
            output logic [1:0] coprocessorIODebugFlags);

    logic[1:0] privMode;

    // Controller signals
    logic[3:0] AluControl;
    logic regWrite, memtoReg, memWrite, AluSrc, wArith, aluSelect;
    logic[1:0] regSel, memRead;
    logic[2:0] Branch, memWidth, memWidth_M;
    logic[2:0] breakSrc;
    logic trapReturn;
    
    // Memory signals
    logic[31:0] instrMemText;
    logic[31:0] instrMemData;
    logic[N-1:0] readData, IM_address;
    logic[7:0] DM_WriteMask;
    
    // Exception signals 
    logic[3:0] exceptSignal_F;
    logic[2:0] exceptSignal_D;
    logic[6:0] exceptSignal_E;
    logic[15:0] exceptSignal;
    logic[15:0] interruptSignal;
    logic[15:0] trapTrigger;

    // CSR signals
    localparam W_CSR = 6;
    logic[N-1:0] csrOut[0:W_CSR-1];
    logic[N-1:0] csrIn;
    logic[N-1:0] cyclesIn;
    logic[11:0] CSR_addr;
    logic csrWriteEnable;
    logic CSR_WriteEnable;

    // Coprocessor aux
    logic[N-1:0] cycleStall_flagOut;
    logic[N-1:0] coprocessorIODataIn_register;
    logic cycleStall, ebreak_flagOut;
    assign coprocessorIODataIn = coprocessorIOControl[2] ? 
                                 readData : 
                                 (coprocessorIOAddr[5]  ? 
                                 IM_address :
                                 coprocessorIODataIn_register);
    assign coprocessorIODebugFlags[0] = cycleStall;

    // CSR
    

    core_status status(.trapTrigger(trapTrigger),
                       .trapReturn(trapReturn),
                       .mstatusCSREnable((CSR_addr == 'h300) & CSR_WriteEnable),
                       .clk(clk),
                       .reset(reset),
                       .csrIn(csrIn),
                       .currentMode(privMode),
                       .mstatus(csrOut[1]));
    
    // csrbank systemControl(.clk(clk),
    //                       .reset(reset),
    //                       .csrIn(csrIn),
    //                       .csrOut(csrOut),


    // );
    // Counters
    flopre #(N) cycle_csr(.clk(clk),
                          .reset(reset),
                          .d(csrOut[5] + 1),
                          .enable(~(|{cycleStall, coprocessorIOControl[3:0]})),
                          .q(csrOut[5]));

    // Coprocessor csr
    flopre #(N) cycleStall_flag(.clk(clk),
                          .reset(~coprocessorIOControl[4]),
                          .d(coprocessorIODataOut),
                          .enable(coprocessorIOControl[4] & coprocessorIOControl[3] & coprocessorIOAddr[12]),
                          .q(cycleStall_flagOut));

    flopre #(1) ebreak_flag(.clk(clk),
                            .reset(reset),
                            .d(coprocessorIOControl[3] ? coprocessorIODataOut[0] : exceptSignal_D[0]),
                            .enable(exceptSignal_D[0] | (coprocessorIOControl[3] & coprocessorIOAddr[12] & coprocessorIOAddr[0])),
                            .q(coprocessorIODebugFlags[1]));


    assign cycleStall = (cycleStall_flagOut == csrOut[5]) & coprocessorIOControl[4];

    // Processing
    controller c(.funct12(instrMemText[31:20]),
                 .funct3(instrMemText[14:12]), 
                 .instr(instrMemText[6:0]),
                 .AluControl(AluControl), 
                 .regWrite(regWrite), 
                 .AluSrc(AluSrc), 
                 .regSel(regSel),
                 .Branch(Branch),
                 .wArith(wArith),
                 .memWidth(memWidth),
                 .memtoReg(memtoReg), 
                 .memRead(memRead),
                 .aluSelect(aluSelect),
                 .breakSrc(breakSrc[2]),
                 .trapReturn(trapReturn),
                 .csrWriteEnable(csrWriteEnable),
                 .exceptSignal_D(exceptSignal_D),
                 .memWrite(memWrite),
                 .privMode(privMode),
                 .coprocessorStall((|{cycleStall, coprocessorIOControl[3:0]})));
                    
    datapath #(N, W_CSR) dp(.reset(reset), 
                            .clk(clk), 
                            .AluSrc(AluSrc), 
                            .regSel(regSel),
                            .aluSelect(aluSelect),
                            .AluControl(AluControl), 
                            .Branch(Branch), 
                            .wArith(wArith),
                            .memWidth(memWidth),
                            .memRead(memRead),
                            .memWrite(memWrite), 
                            .regWrite(regWrite), 
                            .memtoReg(memtoReg),
                            .trapReturn(trapReturn),
                            .trapTrigger({|trapTrigger}),
                            .IM_readData(instrMemText), 
                            .DM_readData(readData), 
                            .IM_addr(IM_address), 
                            .DM_addr(DM_addr), 
                            .DM_writeData(DM_writeData), 
                            .DM_writeEnable(DM_writeEnable), 
                            .DM_readEnable(DM_readEnable),
                            .exceptSignal_F(exceptSignal_F),
                            .exceptSignal_E(exceptSignal_E),
                            .breakSrc(breakSrc[1:0]),
                            .csrIn(csrIn),
                            .csrOut(csrOut),
                            .CSR_addr(CSR_addr),
                            .csrWriteEnable(csrWriteEnable),
                            .CSR_WriteEnable(CSR_WriteEnable),
                            .coprocessorIOAddr(coprocessorIOAddr),
                            .coprocessorIOControl({cycleStall, coprocessorIOControl[3:0]}),
                            .coprocessorIODataOut(coprocessorIODataOut),
                            .coprocessorIODataIn(coprocessorIODataIn_register),
                            .memWidth_M(memWidth_M)
                            );
                      
    imem instrMem (.addr0(IM_address[11:2]),
                  // .clk(clk),
                  //  .addr1({DM_addr[15], DM_addr[10:3]}),
                   .q0(instrMemText)
                  //  .q1(instrMemData)
                   );
    
    dmem dataMem(.clk(clk),
                 .reset(reset),
                 .writeData(coprocessorIOControl[1] ? coprocessorIODataOut : DM_writeData),
                 .readEnable(coprocessorIOControl[2] | DM_readEnable),
                 .writeEnable(coprocessorIOControl[1] | DM_writeEnable),
                 .memWidth(coprocessorIOControl[1] ? {3'b111} : memWidth_M),
                //  .memWidth(memWidth_M),
                 .wordAddr(|{coprocessorIOControl[2:1]} ? coprocessorIOAddr[14:3] : DM_addr[14:3]),
                 .byteOffset(|{coprocessorIOControl[2:1]} ? coprocessorIOAddr[2:0] : DM_addr[2:0]),
                //  .IM_readData(instrMemData),
                //  .dataSelect(DM_addr[15]),
                 .readData(readData));
    // assign DM_readData = readData;
  
    // Exceptions
    // no interrupt support for now
    // order of except signal is according to except code
    // reserved signals are grounded
    except_controller eC(.clk(clk),
                         .reset(reset),
                         .async(1'b0),
                         .MIE(csrOut[1][3]),
                         .exceptSignal(exceptSignal),
                         .interruptSignal(interruptSignal),
                         .breakSrc(breakSrc),
                         .PC_F(IM_address),
                         .CSR_WriteEnable(CSR_WriteEnable),
                         .CSR_addr(CSR_addr),
                         .CSR_In(csrIn),
                         .trapTrigger(trapTrigger),
                         .mcause(csrOut[2]),
                         .mtvec(csrOut[3]),
                         .mepc(csrOut[4]));

    assign exceptSignal = {exceptSignal_E[5],
                          {1'b0},
                          exceptSignal_E[4],
                          exceptSignal_F[2],
                          exceptSignal_D[1],
                          {1'b0}, 
                          exceptSignal_D[1], 
                          exceptSignal_D[1], 
                          exceptSignal_E[3:0],
                          {(exceptSignal_E[5] | exceptSignal_D[0] | exceptSignal_F[2])},
                          exceptSignal_D[2], 
                          exceptSignal_F[1:0]};

  assign interruptSignal = 'b0;

endmodule