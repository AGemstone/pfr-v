// DATAPATH

module datapath #(parameter N = 64, W_CSR = 256)
                (input logic reset, clk,
                 input logic [3:0] AluControl,  // 0010
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
                 output logic [1:0] breakSrc,
					  output logic [1:0] fwA_db, fwB_db,
					  output logic hazard,
					  output logic IF_ID_writeEnable);
                    
    logic PCSrc;
	 logic PCSrc_no;
    logic [N-1:0] PCBranch_E, PCBranch_D, PC_4, aluResult_E, writeData_E, writeData3; 
    logic [N-1:0] signImm_D, readData1_D, readData2_D;
    logic [N-1:0] readDataMasked_M, Mask_writeData;
    logic zero_E, overflow_E, sign_E;
	 logic PCEnable, ControlEnable;
    logic [N-1:0] csrRead_D, aluResultAtom0_E, aluResultAtom1_E;
    logic PC_enable;
	 logic [1:0] fwA, fwB;
	 logic [4:0] rs1, rs2;
	 logic [12:0] controlMux;
	 logic [N-1:0] fwA_out,fwB_out;
	 logic [108:0] qIF_ID;
    logic [413:0] qID_EX;
    logic [399:0] qEX_MEM;
    logic [138:0] qMEM_WB;
	 
	 assign controlMux = ControlEnable ?  // ControlEnable
                        {AluSrc, AluControl, 
                         Branch, memRead, memWrite, regWrite, memtoReg} :
                        'b0;

    fetch #(N) FETCH(.PCSrc_F(qID_EX[412]),  //PCSrc
                     .clk(clk),
                     .reset(reset),
                     .PC_TrapTrigger({{csrOut[3][N-1:2]}, {2'b0}}),
                     .PC_TrapReturn(csrOut[4]),
                     .trapReturn(trapReturn),
                     .interruptSignal(trapTrigger),
                     .PCBranch_F(qID_EX[411: 348]), // PCBranch_D), // qEX_MEM[263:200]), // PCBranch_E
                     .PC_enable(PCEnable),  // ~(|{coprocessorIOControl}) add later
                     .imem_addr_F(IM_addr));

    flopre #(109) IF_ID(.clk(clk),
							   .enable(IF_ID_writeEnable),
							   .reset(reset | IF_ID_reset),
							   .d({controlMux, IM_addr, IM_readData}),
							   .q(qIF_ID));
    
    except_F eC_F(.PC(qIF_ID[95:32]),
                  .iAlign(1'b0),
                  .exceptSignal(exceptSignal_F));

    decode #(N, W_CSR) DECODE(.regWrite_D(qMEM_WB[134]),  // regWrite Output MEM_WB
                              .clk(clk),
                              .Branch(qIF_ID[103:101]),// Branch),
                              .PC_4(qEX_MEM[199:136]),
										.PC_D(qIF_ID[95:32]),  // IM_addr
										.AluSrc(qIF_ID[108]),
                              .writeData3_D(writeData3),  // Output de writeback
                              .regSel0(regSel[0]),
                              .instr_D(qIF_ID[31:0]),
										.wa3_D(qMEM_WB[4:0]),
                              .signImm_D(signImm_D),
                              .csrOut(csrOut),
                              .csrRead_D(csrRead_D),
										.fwA_Br(fwA),
										.fwB_Br(fwB),
										.fwA_D(fwA_out),
										.fwB_D(fwB_out),
                              .readData1_D(readData1_D),
                              .readData2_D(readData2_D),
                              .readDataDB_D(coprocessorIODataIn),  // Sufijo DB debugging
                              .writeDataDB_D(coprocessorIODataOut),
                              .readRegDB_D (coprocessorIOAddr[4:0]),
                              .writeRegDB_D(coprocessorIOAddr[4:0]),
                              .weDB_D(coprocessorIOControl[0]),
                              .csrAddrDB_D(coprocessorIOAddr[11:0]),
                              .csrDB_D(coprocessorIOControl[3]),
										.rs1(rs1),
										.rs2(rs2),
										.PCBranch_D(PCBranch_D),
										.PCSrc_D(PCSrc));

	 flopr #(413) ID_EX (.clk(clk),
								// .enable(ID_EX_writeEnable),
	                     .reset(reset),
								.d({PCSrc, PCBranch_D, rs2, rs1, qIF_ID[108:96], qIF_ID[95:32], signImm_D, csrRead_D,
                            readData1_D, readData2_D, qIF_ID[11:7]}), // Preguntar sobre este ultimo
								.q(qID_EX));
                                       
    execute #(N) EXECUTE(.AluSrc(qID_EX[337]),  // AluSrc
                         .AluControl(qID_EX[336:333]), // AluControl
                         .PC_E(qID_EX[324:261]),  // IM_addr
                         .PC4_E(PC_4), // Preguntar origen de registro
                         .regSel1(regSel[1]),
                         .signImm_E(qID_EX[260:197]),  // sign_Imm_D
                         .readData1_E(fwA_out), 
                         .readData2_E(fwB_out), 
                         .PCBranch_E(PCBranch_E),  // REMOVE
                         .aluResult_E(aluResult_E),
                         .writeData_E(writeData_E),
                         .wArith(wArith),
                         .zero_E(zero_E),
                         .overflow_E(overflow_E),
                         .sign_E(sign_E),
                         .aluSelect(aluSelect),
                         .CSRRead_E(qID_EX[196:133]),
                         .result1_Atom(aluResultAtom1_E));

	 flopr #(400) EX_MEM (.clk(clk),
                         .reset(reset),
                         .d({fwB_out, qID_EX[332:325], qID_EX[68:5], PCBranch_E, PC_4, // Agregar como input al decode
                             aluResult_E, aluResultAtom1_E, zero_E, overflow_E, sign_E,
									  qID_EX[4:0]}),
                         .q(qEX_MEM));	
    
    except_E eC_E (.DM_addr(qEX_MEM[135:72]),
                   .memOp({qEX_MEM[330], qEX_MEM[331]}),  //{memWrite, memRead[0]}
                   .memWidth(memWidth),
                   .exceptSignal(exceptSignal_E));

    memory #(N) MEMORY(.Branch_E(qEX_MEM[335:333]),  // Branch
                       .zero_E(qEX_MEM[7]),
                       .sign_E(qEX_MEM[5]),
                       .overflow_E(qEX_MEM[6]),
                       .PCSrc_W(PCSrc_no));  // Output para Fetch, no va para el registro

    forwarding FORWARDING (.EX_MEM_RegWrite(qEX_MEM[329]),  // Done
                           .MEM_WB_RegWrite(qMEM_WB[134]),  // Done
                           .EX_MEM_RegisterRd(qEX_MEM[4:0]),  // Done
                           .MEM_WB_RegisterRd(qMEM_WB[4:0]),  // Done
                           .ID_EX_RegisterRs1(qID_EX[342:338]), // Done
                           .ID_EX_RegisterRs2(qID_EX[347:343]),  // Done
                           .fwA(fwA),  // Output
                           .fwB(fwB));  // Output

	 mux3 FWA (.s(fwA),  // COPY 2 for BRANCHING
              .d0(qID_EX[132:69]), // readData1_E
              .d1(writeData3),
              .d2(qEX_MEM[135:72]),  // aluResult_E
              .y(fwA_out));

    mux3 FWB (.s(fwB),
             .d0(qID_EX[68:5]),  // Done readData2_E
             .d1(writeData3),
             .d2(qEX_MEM[135:72]), // aluResult_E
             .y(fwB_out));


    hazard HDU (.ID_EX_MemRead(qID_EX[329]),  // Done
					 .IF_ID_Branch(qIF_ID[103:101]),
                .ID_EX_RegisterRd(qID_EX[4:0]),  // Done
					 .EX_MEM_RegisterRd(qEX_MEM[4:0]),
                .IF_ID_RegisterRs1(rs1),  // Arreglar decode para que tenga este output 
                .IF_ID_RegisterRs2(rs2),
					 .PCSrc(qID_EX[412]),
                .ControlEnable(ControlEnable),
                .PCEnable(PCEnable),
                .IF_ID_writeEnable(IF_ID_writeEnable),
				    .IF_ID_reset(IF_ID_reset)	 // output IF_ID_reset
                );

    assign DM_writeEnable = qEX_MEM[330]; // memWrite;
    assign DM_readEnable = qEX_MEM[331]; // memRead[0];
    assign DM_writeData = qEX_MEM[399:336]; //readData2_D;  // FwBOut por registro
    assign DM_addr = qEX_MEM[135:72];
	 assign memWidth_M = memWidth;

    assign CSR_addr = qIF_ID[31:20];
    assign CSR_WriteEnable = csrWriteEnable;
    assign csrIn = qEX_MEM[71:8]; // aluResultAtom1_E;

	 flopr #(139) MEM_WB (.clk(clk),
                         .reset(reset), 
                         .d({qEX_MEM[332], qEX_MEM[74:72], qEX_MEM[329:328], qEX_MEM[135:72], readDataMasked_M, qEX_MEM[4:0]}),
                         .q(qMEM_WB));

    writeback #(N) WRITEBACK(.aluResult_W(qMEM_WB[132:69]), 
                             // .DM_readData_W(readDataMasked_M), // (qMEM_WB[68:5]), 
                             .memtoReg(qMEM_WB[133]),   // memtoReg
                             .writeData3_W(writeData3),
									  .DM_readData_W(DM_readData),
                             .memWidth(memWidth),
                             .signedRead(qMEM_WB[138]),  //memRead[1]
                             .byteOffset(qMEM_WB[137:135]));

    assign breakSrc = {exceptSignal_E[6], exceptSignal_F[3]};
	 assign fwA_db = fwA;
    assign fwB_db = fwB;
    assign hazard = ControlEnable | PCEnable | IF_ID_writeEnable;
endmodule
