// DATAPATH

module datapath #(parameter N = 64, W_CSR = 256)
                (input logic reset, clk,
                 input logic [3:0] AluControl,
                 input logic [2:0] exceptSignalD, Branch, memWidth,
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
					  output logic [N-1:0] csrIn_D,
                 output logic [N-1:0] IM_addr, DM_addr, DM_writeData,  // IM_addr add logic
                 output logic [11:0] CSR_addr,
					  output logic [11:0] CSR_addr_D,
                 output logic DM_writeEnable, DM_readEnable,
                 output logic CSR_WriteEnable,
					  output logic CSR_WriteEnable_D,
                 output logic [2:0] memWidth_M,
                 output logic [3:0] exceptSignal_F, 
                 output logic [6:0] exceptSignal_E, 
                 output logic [1:0] breakSrc,
					  output logic [1:0] fwA_db, fwB_db,
					  output logic hazard,
					  output logic IF_ID_writeEnable,
					  output logic [2:0] exceptSignal_D);
                    
    logic PCSrc;
	 logic branch_hazard;
	 logic PCSrc_no;
    logic [N-1:0] PCBranch_E, PCBranch_D, PC_4, aluResult_E, writeData_E, writeData3; 
    logic [N-1:0] signImm_D, readData1_D, readData2_D;
    logic [N-1:0] readDataMasked_M, Mask_writeData;
    logic zero_E, overflow_E, sign_E;
	 logic illegal_instr;
	 logic PCEnable, ControlEnable;
    logic [N-1:0] csrRead_D, aluResultAtom0_E, aluResultAtom1_E;
    logic PC_enable;
	 logic [1:0] fwA, fwB;
	 logic [4:0] rs1, rs2;
	 logic [23:0] controlMux;
	 logic [N-1:0] fwA_out,fwB_out;
	 logic [119:0] qIF_ID;
    logic [435:0] qID_EX;
    logic [425:0] qEX_MEM;
    logic [142:0] qMEM_WB;
	 
	 assign controlMux = ControlEnable ?
                        {exceptSignalD, csrWriteEnable, memWidth, wArith, aluSelect, regSel, AluSrc, AluControl, 
                         Branch, memRead, memWrite, regWrite, memtoReg} :
                        'b0;

    fetch #(N) FETCH(.PCSrc_F(qID_EX[412]),
                     .clk(clk),
                     .reset(reset),
                     .PC_TrapTrigger({{csrOut[3][N-1:2]}, {2'b0}}),
                     .PC_TrapReturn(csrOut[4]),
                     .trapReturn(trapReturn),
                     .interruptSignal(qID_EX[435]), // trapTrigger
                     .PCBranch_F(qID_EX[411: 348]), // PCBranch_D
                     .PC_enable(PCEnable && ~(|{coprocessorIOControl})),
                     .imem_addr_F(IM_addr));

    flopre #(120) IF_ID(.clk(clk),
							   .enable(IF_ID_writeEnable && ~(|{coprocessorIOControl})),
							   .reset(reset | IF_ID_reset),
							   .d({controlMux, IM_addr, IM_readData}),
							   .q(qIF_ID));
    
    except_F eC_F(.PC(qIF_ID[95:32]),
                  .iAlign(1'b0),
                  .exceptSignal(exceptSignal_F));

    decode #(N, W_CSR) DECODE(.regWrite_D(qMEM_WB[70]),
                              .clk(clk),
                              .Branch(qIF_ID[103:101]),
										.branch_hazard(branch_hazard),
                              .PC_4(qEX_MEM[199:136]),
										.PC_D(qIF_ID[95:32]),  // IM_addr
										.AluSrc(qIF_ID[108]),
                              .writeData3_D(writeData3),  // Output de writeback
                              .regSel0(qIF_ID[109]),
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
                              .readDataDB_D(coprocessorIODataIn),
                              .writeDataDB_D(coprocessorIODataOut),
                              .readRegDB_D (coprocessorIOAddr[4:0]),
                              .writeRegDB_D(coprocessorIOAddr[4:0]),
                              .weDB_D(coprocessorIOControl[0]),
                              .csrAddrDB_D(coprocessorIOAddr[11:0]),
                              .csrDB_D(coprocessorIOControl[3]),
										.rs1(rs1),
										.rs2(rs2),
										.PCBranch_D(PCBranch_D),
										.PCSrc_D(PCSrc),
										.illegal_instr(illegal_instr));

	 flopre #(436) ID_EX (.clk(clk),
								.enable(~(|{coprocessorIOControl})),
	                     .reset(reset),
								.d({trapTrigger, qIF_ID[119:117], qIF_ID[31:20], qIF_ID[116:110], PCSrc, PCBranch_D, rs2, rs1, qIF_ID[108:96], qIF_ID[95:32], signImm_D, csrRead_D,
                            readData1_D, readData2_D, qIF_ID[11:7]}),
								.q(qID_EX));
                                       
    execute #(N) EXECUTE(.AluSrc(qID_EX[337]),
                         .AluControl(qID_EX[336:333]),
                         .PC_E(qID_EX[324:261]),
                         .PC4_E(PC_4),
                         .regSel1(qID_EX[413]),
                         .signImm_E(qID_EX[260:197]),
                         .readData1_E(fwA_out), 
                         .readData2_E(fwB_out), 
                         .PCBranch_E(PCBranch_E),  // Unused signal, feel free to remove later
                         .aluResult_E(aluResult_E),
                         .writeData_E(writeData_E),
                         .wArith(qID_EX[415]),
								 .PCSrc(qID_EX[412]),
                         .zero_E(zero_E),
                         .overflow_E(overflow_E),
                         .sign_E(sign_E),
                         .aluSelect(qID_EX[414]),
                         .CSRRead_E(qID_EX[196:133]),
                         .result1_Atom(aluResultAtom1_E));

	 flopre #(426) EX_MEM (.clk(clk),
	                      .enable(~(|{coprocessorIOControl})),
                         .reset(reset),
                         .d({qID_EX[347:338], qID_EX[431:420], qID_EX[419:416], fwB_out, qID_EX[332:325], qID_EX[68:5], PCBranch_E, PC_4,
                             aluResult_E, aluResultAtom1_E, zero_E, overflow_E, sign_E,
									  qID_EX[4:0]}),
                         .q(qEX_MEM));	
    
    except_E eC_E (.DM_addr(qEX_MEM[135:72]),
                   .memOp({qEX_MEM[330], qEX_MEM[331]}),  //{memWrite, memRead[0]}
                   .memWidth(qEX_MEM[402:400]),
                   .exceptSignal(exceptSignal_E));

    memory #(N) MEMORY(.DM_readData_E(DM_readData),
                       .memWidth(qEX_MEM[402:400]),
                       .signedRead(qEX_MEM[332]),
                       .byteOffset(qEX_MEM[74:72]),
                       .readDataMasked_M(readDataMasked_M));

    forwarding FORWARDING (.EX_MEM_RegWrite(qEX_MEM[329]),
	                        .MEM_WB_MemRead(qMEM_WB[142]),
                           .MEM_WB_RegWrite(qMEM_WB[70]),
                           .EX_MEM_RegisterRd(qEX_MEM[4:0]),
                           .MEM_WB_RegisterRd(qMEM_WB[4:0]),
                           .ID_EX_RegisterRs1(qID_EX[342:338]),
                           .ID_EX_RegisterRs2(qID_EX[347:343]),
                           .fwA(fwA),
                           .fwB(fwB));

	 mux3 FWA (.s(fwA),
              .d0(qID_EX[132:69]),
              .d1(qID_EX[327] ? writeData3 : qMEM_WB[141:78]),
              .d2(qEX_MEM[135:72]),
              .y(fwA_out));

    mux3 FWB (.s(fwB),
             .d0(qID_EX[68:5]),
             .d1(qID_EX[327] ? writeData3 : qMEM_WB[141:78]),
             .d2(qEX_MEM[135:72]),
             .y(fwB_out));


    hazard HDU (.clk(clk),
	             .reset(reset),
	             .ID_EX_MemRead(qID_EX[328]),
					 .IF_ID_Branch(qIF_ID[103:101]),
                .ID_EX_RegisterRd(qID_EX[4:0]),
					 .EX_MEM_RegisterRd(qEX_MEM[4:0]),
					 .trapTrigger(trapTrigger),
					 .interruptSignal_D(|{qID_EX[434:432]} && |{csrOut[2]}),
                .IF_ID_RegisterRs1(rs1),
                .IF_ID_RegisterRs2(rs2),
					 .ID_EX_PCSrc(qID_EX[412]),
					 .PCSrc(PCSrc),
                .ControlEnable(ControlEnable),
                .PCEnable(PCEnable),
                .IF_ID_writeEnable(IF_ID_writeEnable),
				    .IF_ID_reset(IF_ID_reset),
					 .branch_hazard(branch_hazard)
                );

    assign DM_writeEnable = qID_EX[327]; // memWrite;
    assign DM_readEnable = qID_EX[328]; // memRead[0];
    assign DM_writeData = fwB_out;
    assign DM_addr = aluResult_E;
	 assign memWidth_M = qID_EX[418:416];
	 assign exceptSignal_D = qIF_ID[119:117]; // exceptSignalD; 

    assign CSR_addr = qEX_MEM[415:404]; 
	 assign CSR_addr_D = qID_EX[431:420]; // IM_readData[31:20];
    assign CSR_WriteEnable = qEX_MEM[403]; 
	 assign CSR_WriteEnable_D = qID_EX[419]; // csrWriteEnable;
	 assign csrIn_D = aluResultAtom1_E;
    assign csrIn = qEX_MEM[71:8]; // aluResultAtom1_E;

	 flopre #(143) MEM_WB (.clk(clk),
	                      .enable(~(|{coprocessorIOControl})),
                         .reset(reset), 
                         .d({qEX_MEM[331], readDataMasked_M, qEX_MEM[402:400], qEX_MEM[332], qEX_MEM[74:72], qEX_MEM[329:328], qEX_MEM[135:72], qEX_MEM[4:0]}),
                         .q(qMEM_WB));

    writeback #(N) WRITEBACK(.aluResult_W(qMEM_WB[68:5]), 
                             .memtoReg(qMEM_WB[69]),
									  .readDataMasked_W(qMEM_WB[141:78]),
                             .writeData3_W(writeData3));

    assign breakSrc = {exceptSignal_E[6], exceptSignal_F[3]};
	 assign fwA_db = fwA;
    assign fwB_db = fwB;
    assign hazard = ControlEnable | PCEnable | IF_ID_writeEnable;
endmodule