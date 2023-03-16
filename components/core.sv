module core #(parameter N = 64)
            (input logic clk, reset,
            input logic[N-1:0] DM_readData,
            output logic [N-1:0] DM_writeData, DM_addr,
            output logic DM_writeEnable, DM_readEnable,
            input logic dump,
            input logic [14:0] coprocessorIOAddr,
            input logic [2:0] coprocessorIOControl,
            input logic [N-1:0] coprocessorIODataOut,
            output logic [N-1:0] coprocessorIODataIn);

    logic[1:0] privMode;

    // Controller signals
    logic[3:0] AluControl;
    logic regWrite, memtoReg, memWrite, AluSrc, wArith, aluSelect;
    logic[1:0] regSel, memRead;
    logic[2:0] Branch, memMask;
    logic[2:0] breakSrc;
    logic trapReturn;
    
    // Memory signals
    logic[31:0] instrMemData;
    logic[N-1:0] readData, IM_address;
    
    // Exception signals 
    logic[3:0] exceptSignal_F;
    logic[2:0] exceptSignal_D;
    logic[6:0] exceptSignal_E;
    logic[15:0] exceptSignal;
    logic[15:0] interruptSignal;
    logic[15:0] trapTrigger;

    // CSR signals
    localparam W_CSR = 5;
    logic[N-1:0] csrOut[0:W_CSR-1];
    logic[N-1:0] csrIn;
    logic[11:0] CSR_addr;
    logic csrWriteEnable;
    logic CSR_WriteEnable;

    // CSR
    flopre #(N) mscratch_csr(.clk(clk),
                             .reset(reset),
                             .d(csrIn),
                             .enable((CSR_addr == 'h340) && CSR_WriteEnable),
                             .q(csrOut[0])); 

    core_status status(.trapTrigger(trapTrigger),
                       .trapReturn(trapReturn),
                       .mstatusCSREnable((CSR_addr == 'h300) && CSR_WriteEnable),
                       .clk(clk),
                       .reset(reset),
                       .csrIn(csrIn),
                       .currentMode(privMode),
                       .mstatus(csrOut[1]));
    
    // Processing
    controller c(.funct12(instrMemData[31:20]),
                 .funct3(instrMemData[14:12]), 
                 .instr(instrMemData[6:0]),
                 .AluControl(AluControl), 
                 .regWrite(regWrite), 
                 .AluSrc(AluSrc), 
                 .regSel(regSel),
                 .Branch(Branch),
                 .wArith(wArith),
                 .memMask(memMask),
                 .memtoReg(memtoReg), 
                 .memRead(memRead),
                 .aluSelect(aluSelect),
                 .breakSrc(breakSrc[2]),
                 .trapReturn(trapReturn),
                 .csrWriteEnable(csrWriteEnable),
                 .exceptSignal_D(exceptSignal_D),
                 .memWrite(memWrite),
                 .privMode(privMode));                    
                    
    datapath #(N, W_CSR) dp(.reset(reset), 
                            .clk(clk), 
                            .AluSrc(AluSrc), 
                            .regSel(regSel),
                            .aluSelect(aluSelect),
                            .AluControl(AluControl), 
                            .Branch(Branch), 
                            .wArith(wArith),
                            .memMask(memMask),
                            .memRead(memRead),
                            .memWrite(memWrite), 
                            .regWrite(regWrite), 
                            .memtoReg(memtoReg),
                            .trapReturn(trapReturn),
                            .trapTrigger({|trapTrigger}),
                            .IM_readData(instrMemData), 
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
                            .coprocessorIOControl(coprocessorIOControl),
                            .coprocessorIODataOut(coprocessorIODataOut),
                            .coprocessorIODataIn(coprocessorIODataIn)
                            );
                      
    imem instrMem (.addr(IM_address[7:2]),
                   .q(instrMemData));
                                    
    // dmem dataMem(.clk(clk), 
    //              .memWrite(DM_writeEnable), 
    //              .memRead(DM_readEnable), 
    //              .address(DM_addr[9:3]), 
    //              .writeData(DM_writeData), 
    //              .readData(readData), 
    //              .dump(dump));
    // assign DM_readData = readData;

    dmemip dataMem(.clock(clk),
                   .data(DM_writeData),
                   .address(DM_addr[12:3]),
                   .rden(DM_readEnable),
                   .wren(DM_writeEnable),
                   .q(readData));
  
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