// DATAPATH

module datapath #(parameter N = 64, W_CSR = 256)
                (input logic reset, clk,
                 input logic [3:0] AluControl,
                 input logic[2:0] Branch, memMask,
                 input logic[1:0] regSel, memRead,
                 input logic AluSrc,
                 input logic memWrite,
                 input logic regWrite,	
                 input logic memtoReg,
                 input logic wArith,
                 input logic aluSelect,
                 input logic csrWriteEnable,
                 input logic trapReturn,
                 input logic trapTrigger,
                 input logic [31:0] IM_readData,
                 input logic [N-1:0] DM_readData,
                 input logic[N-1:0] csrOut[0:W_CSR-1],
                 input logic [14:0] coprocessorIOAddr,
                 input logic [2:0] coprocessorIOControl,
                 input logic [N-1:0] coprocessorIODataOut,
                 output logic [N-1:0] coprocessorIODataIn,
                 output logic[N-1:0] csrIn,
                 output logic [N-1:0] IM_addr, DM_addr, DM_writeData,
                 output logic [11:0] CSR_addr,
                 output logic DM_writeEnable, DM_readEnable,
                 output logic CSR_WriteEnable,
                 output logic[3:0] exceptSignal_F, 
                 output logic[6:0] exceptSignal_E, 
                 output logic[1:0] breakSrc);
                    
    logic PCSrc;
    logic [N-1:0] PCBranch_E, PC_4, aluResult_E, writeData_E, writeData3; 
    logic [N-1:0] signImm_D, readData1_D, readData2_D;
    logic [N-1:0] Mask_readData, Mask_writeData;
    logic zero_E, overflow_E, sign_E;
    logic [N-1:0] csrRead_D, aluResultAtom0_E, aluResultAtom1_E;

    fetch #(N) FETCH(.PCSrc_F(PCSrc),
                     .clk(clk),
                     .reset(reset),
                     .PC_TrapTrigger({{2'b0}, {csrOut[3][N-1:4]}, {2'b0}}),
                     .PC_TrapReturn(csrOut[4]),
                     .trapReturn(trapReturn),
                     .interruptSignal(trapTrigger),
                     .PCBranch_F(PCBranch_E),
                     .imem_addr_F(IM_addr));
    
    except_F eC_F(.PC(IM_addr),
                  .iAlign(1'b0),
                  .exceptSignal(exceptSignal_F));


    decode #(N, W_CSR) DECODE(.regWrite_D(regWrite),
                              .clk(clk),
                              .Branch(Branch),
                              .PC_4(PC_4),
                              .writeData3_D(writeData3),
                              .regSel0(regSel[0]),
                              .instr_D(IM_readData),
                              .signImm_D(signImm_D),
                              .csrOut(csrOut),
                              .csrRead_D(csrRead_D),
                              .readData1_D(readData1_D),
                              .readData2_D(readData2_D),
                              .readDataDB_D(coprocessorIODataIn),
                              .writeDataDB_D(coprocessorIODataOut),
                              .readRegDB_D (coprocessorIOAddr[4:0]),
                              .writeRegDB_D(coprocessorIOAddr[4:0]),
                              .weDB_D(coprocessorIOControl[0]));
                                       
    execute #(N) EXECUTE(.AluSrc(AluSrc),
                         .AluControl(AluControl),
                         .PC_E(IM_addr),
                         .PC4_E(PC_4),
                         .regSel1(regSel[1]),
                         .signImm_E(signImm_D),
                         .readData1_E(readData1_D), 
                         .readData2_E(readData2_D), 
                         .PCBranch_E(PCBranch_E), 
                         .aluResult_E(DM_addr), 
                         .writeData_E(writeData_E),
                         .wArith(wArith),
                         .zero_E(zero_E),
                         .overflow_E(overflow_E),
                         .sign_E(sign_E),
                         .aluSelect(aluSelect),
                         .CSRRead_E(csrRead_D),
                         .result1_Atom(aluResultAtom1_E));
    
    except_E eC_E (.DM_addr(DM_addr),
                   .memOp({memWrite, memRead[0]}),
                   .exceptSignal(exceptSignal_E));

    branching BRANCH(.Branch_W(Branch),
                   .zero_W(zero_E),
                   .sign_W(sign_E),
                   .overflow_W(overflow_E),
                   .PCSrc_W(PCSrc));

    memmask MEM_MASK(.DM_RD(DM_readData),
                     .DM_WD(writeData_E),
                     .memMask(memMask),
                     .readOp(memRead[1]),
                     .readData_M(Mask_readData),
                     .writeData_M(DM_writeData));

    assign DM_writeEnable = memWrite;
    assign DM_readEnable = memRead[0];

    assign CSR_addr = IM_readData[31:20];
    assign CSR_WriteEnable = csrWriteEnable;
    assign csrIn = aluResultAtom1_E;

    writeback #(N) WRITEBACK(.aluResult_W(DM_addr), 
                             .DM_readData_W(Mask_readData), 
                             .memtoReg(memtoReg), 
                             .writeData3_W(writeData3));

    assign breakSrc = {exceptSignal_E[6], exceptSignal_F[3]};
endmodule
