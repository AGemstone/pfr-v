// DATAPATH

module datapath #(parameter N = 64)
                (input logic reset, clk,
                 input logic [3:0] AluControl,
                 input logic[2:0] Branch, memMask,
                 input logic[1:0] regSel, memRead,
                 input logic AluSrc,
                 input logic memWrite,
                 input logic regWrite,	
                 input logic memtoReg,
                 input logic wArith,
                 input logic [31:0] IM_readData,
                 input logic [N-1:0] DM_readData,
                 input logic [N-1:0] PC_Trap,
                 output logic [N-1:0] IM_addr, DM_addr, DM_writeData,
                 output logic DM_writeEnable, DM_readEnable,
                 output logic[3:0] exceptSignal_F, 
                 output logic[6:0] exceptSignal_E, 
                 output logic[1:0] breakSrc);
                    
    logic PCSrc;
    logic [N-1:0] PCBranch_E, PC_4, aluResult_E, writeData_E, writeData3; 
    logic [N-1:0] signImm_D, readData1_D, readData2_D;
    logic [N-1:0] Mask_readData, Mask_writeData;
    logic zero_E, overflow_E, sign_E;

    fetch #(64) FETCH(.PCSrc_F(PCSrc),
                      .clk(clk),
                      .reset(reset),
                      .PC_Trap(PC_Trap),
                      .interruptSignal(1'b0),
                      .PCBranch_F(PCBranch_E),
                      .imem_addr_F(IM_addr));
    
    except_F eC_F(.PC(IM_addr),
                  .iAlign(1'b0),
                  .exceptSignal(exceptSignal_F));


    decode #(64) DECODE(.regWrite_D(regWrite),
                        .clk(clk),
                        .Branch(Branch),
                        .PC_4(PC_4),
                        .writeData3_D(writeData3),
                        .regSel0(regSel[0]),
                        .instr_D(IM_readData),
                        .signImm_D(signImm_D), 
                        .readData1_D(readData1_D),
                        .readData2_D(readData2_D));	
                                       
    execute #(64) EXECUTE(.AluSrc(AluSrc),
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
                          .sign_E(sign_E));
    
    except_E eC_E (.DM_addr(DM_addr),
                   .memOp(memWrite),
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

    // Salida de señales de control:
    assign DM_writeEnable = memWrite;
    assign DM_readEnable = memRead[0];
        
    writeback #(64) WRITEBACK(.aluResult_W(DM_addr), 
                               .DM_readData_W(Mask_readData), 
                               .memtoReg(memtoReg), 
                               .writeData3_W(writeData3));

    assign breakSrc = {exceptSignal_E[6], exceptSignal_F[3]};
endmodule
