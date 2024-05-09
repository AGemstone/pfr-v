// DATAPATH

module datapath #(parameter N = 64, W_CSR = 256)
                (input logic reset, clk,
                 input logic [3:0] AluControl,
                 input logic [2:0] Branch, memWidth,
                 input logic [1:0] regSel, memRead,
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
                 input logic [N-1:0] csrOut[0:W_CSR-1],
                 input logic [14:0] coprocessorIOAddr,
                 input logic [4:0] coprocessorIOControl,
                 input logic [N-1:0] coprocessorIODataOut,
                 output logic [N-1:0] coprocessorIODataIn,
                 output logic [N-1:0] csrIn,
                 output logic [N-1:0] IM_addr, DM_addr, DM_writeData,
                 output logic [11:0] CSR_addr,
                 output logic DM_writeEnable, DM_readEnable,
                 output logic CSR_WriteEnable,
                 output logic [2:0] memWidth_M,
                 output logic [3:0] exceptSignal_F, 
                 output logic [6:0] exceptSignal_E, 
                 output logic [1:0] breakSrc);
                    
    logic PCSrc;
    logic [N-1:0] PCBranch_E, PC_4, aluResult_E, writeData_E, writeData3; 
    logic [N-1:0] signImm_D, readData1_D, readData2_D;
    logic [N-1:0] readDataMasked_M, Mask_writeData;
    logic zero_E, overflow_E, sign_E;
    logic [N-1:0] csrRead_D, aluResultAtom0_E, aluResultAtom1_E;
    logic PC_enable;
	 logic [4:0] rs1, rs2;
	 logic [95:0] qIF_ID;
    logic [398:0] qID_EX;
    logic [391:0] qEX_MEM;
    logic [132:0] qMEM_WB;

    fetch #(N) FETCH(.PCSrc_F(PCSrc),
                     .clk(clk),
                     .reset(reset),
                     .PC_TrapTrigger({{csrOut[3][N-1:2]}, {2'b0}}),
                     .PC_TrapReturn(csrOut[4]),
                     .trapReturn(trapReturn),
                     .interruptSignal(trapTrigger),
                     .PCBranch_F(PCBranch_E),
                     .PC_enable(~(|{coprocessorIOControl})),
                     .imem_addr_F(IM_addr));

    flopr #(96) IF_ID(.clk(clk),
							 .reset(reset),
							 .d({IM_addr, IM_readData}),
							 .q(qIF_ID));
    
    except_F eC_F(.PC(qIF_ID[95:32]),
                  .iAlign(1'b0),
                  .exceptSignal(exceptSignal_F));

    decode #(N, W_CSR) DECODE(.regWrite_D(regWrite),
                              .clk(clk),
                              .Branch(Branch),
                              .PC_4(PC_4),
                              .writeData3_D(writeData3),  // Output de writeback
                              .regSel0(regSel[0]),
                              .instr_D(qIF_ID[31:0]),
                              .signImm_D(signImm_D),
                              .csrOut(csrOut),
                              .csrRead_D(csrRead_D),
                              .readData1_D(readData1_D),
                              .readData2_D(readData2_D),
                              .readDataDB_D(coprocessorIODataIn),
                              .writeDataDB_D(coprocessorIODataOut),
                              .readRegDB_D (coprocessorIOAddr[4:0]),
                              .writeRegDB_D(coprocessorIOAddr[4:0]),
                              .weDB_D(coprocessorIOControl[0]),
                              .csrAddrDB_D(coprocessorIOAddr[11:0]),
                              .csrDB_D(coprocessorIOControl[3]),
										.rs1(rs1),
										.rs2(rs2));

	 flopr #(399) ID_EX (.clk(clk),
	                     .reset(reset),
								.d({rs2, rs1, qIF_ID[95:32], signImm_D, csrRead_D,
                            readData1_D, readData2_D, readDataDB_D, qIF_ID[4:0]}), // Preguntar sobre este ultimo
								.q(qID_EX));
                                       
    execute #(N) EXECUTE(.AluSrc(AluSrc),
                         .AluControl(AluControl),
                         .PC_E(qID_EX[388:325]),
                         .PC4_E(PC_4), // Preguntar origen de registro
                         .regSel1(regSel[1]),
                         .signImm_E(qID_EX[324:261]),
                         .readData1_E(qID_EX[196:133]), 
                         .readData2_E(qID_EX[132:69]), 
                         .PCBranch_E(PCBranch_E), 
                         .aluResult_E(DM_addr), 
                         .writeData_E(writeData_E),
                         .wArith(wArith),
                         .zero_E(zero_E),
                         .overflow_E(overflow_E),
                         .sign_E(sign_E),
                         .aluSelect(aluSelect),
                         .CSRRead_E(qID_EX[260:197]),
                         .result1_Atom(aluResultAtom1_E));

	 flopr #(392) EX_MEM (.clk(clk),
                         .reset(reset), 
                         .d({qID_EX[132:69], PCBranch_E, PC_4, // Agregar como input al decode
                             zero_E, overflow_E, sign_E, DM_addr, writeData_E, aluResultAtom1_E, qID_EX[4:0]}),
                         .q(qEX_MEM));	
    
    except_E eC_E (.DM_addr(qEX_MEM[196:133]),
                   .memOp({memWrite, memRead[0]}),
                   .memWidth(memWidth),
                   .exceptSignal(exceptSignal_E));

    memory #(N) MEMORY(.Branch_E(Branch),
                       .zero_E(qEX_MEM[199]),
                       .sign_E(qEX_MEM[197]),
                       .overflow_E(qEX_MEM[198]),
                       .PCSrc_W(PCSrc),  // Output para Fetch, no va para el registro
                       .DM_readData_E(qEX_MEM[391:328]),  // Cambiar por readData2, DM_readData
                       .memWidth(memWidth),
                       .signedRead(memRead[1]),
                       .byteOffset(qEX_MEM[135:133]),
                       .readDataMasked_M(readDataMasked_M));

    assign DM_writeEnable = memWrite;
    assign DM_readEnable = memRead[0];
    assign DM_writeData = readData2_D;
    assign memWidth_M = memWidth;

    assign CSR_addr = qIF_ID[31:20];
    assign CSR_WriteEnable = csrWriteEnable;
    assign csrIn = aluResultAtom1_E;

	 flopr #(133) MEM_WB (.clk(clk),
                         .reset(reset), 
                         .d({qEX_MEM[196:133], readDataMasked_M, 
                             qEX_MEM[4:0]}),
                         .q(qMEM_WB));

    writeback #(N) WRITEBACK(.aluResult_W(qMEM_WB[132:69]), 
                             .DM_readData_W(qMEM_WB[68:5]), 
                             .memtoReg(memtoReg), 
                             .writeData3_W(writeData3));

    assign breakSrc = {exceptSignal_E[6], exceptSignal_F[3]};
endmodule
