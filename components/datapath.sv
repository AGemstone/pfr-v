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
                 output logic [1:0] breakSrc);
                    
    logic PCSrc;
    logic [N-1:0] PCBranch_E, PC_4, aluResult_E, writeData_E, writeData3; 
    logic [N-1:0] signImm_D, readData1_D, readData2_D;
    logic [N-1:0] readDataMasked_M, Mask_writeData;
    logic zero_E, overflow_E, sign_E;
	 logic ControlEnable;
    logic [N-1:0] csrRead_D, aluResultAtom0_E, aluResultAtom1_E;
    logic PC_enable;
	 logic [12:0] controlMux;
	 logic [95:0] qIF_ID;
    logic [332:0] qID_EX;
    logic [330:0] qEX_MEM;
    logic [129:0] qMEM_WB;
	 
	 
	 assign controlMux = ControlEnable ? 
                        {AluSrc, AluControl, 
                         Branch, memRead, memWrite, regWrite, memtoReg} :
                        'b0;

    fetch #(N) FETCH(.PCSrc_F(PCSrc),
                     .clk(clk),
                     .reset(reset),
                     .PC_TrapTrigger({{csrOut[3][N-1:2]}, {2'b0}}),
                     .PC_TrapReturn(csrOut[4]),
                     .trapReturn(trapReturn),
                     .interruptSignal(trapTrigger),
                     .PCBranch_F(qEX_MEM[258:195]), // PCBranch_E
                     .PC_enable(1),  // ~(|{coprocessorIOControl}) add later
                     .imem_addr_F(IM_addr));

    flopr #(96) IF_ID(.clk(clk),
							 .reset(reset),
							 .d({IM_addr, IM_readData}),
							 .q(qIF_ID));
    
    except_F eC_F(.PC(qIF_ID[95:32]),
                  .iAlign(1'b0),
                  .exceptSignal(exceptSignal_F));

    decode #(N, W_CSR) DECODE(.regWrite_D(qMEM_WB[129]),  // regWrite Output MEM_WB
                              .clk(clk),
                              .Branch(Branch),
                              .PC_4(qEX_MEM[194:131]),
                              .writeData3_D(writeData3),  // Output de writeback
                              .regSel0(regSel[0]),
                              .instr_D(qIF_ID[31:0]),
                              .signImm_D(signImm_D),
                              .csrOut(csrOut),
                              .csrRead_D(csrRead_D),
                              .readData1_D(readData1_D),
                              .readData2_D(readData2_D),
                              .readDataDB_D(coprocessorIODataIn),  // Sufijo DB debugging
                              .writeDataDB_D(coprocessorIODataOut),
                              .readRegDB_D (coprocessorIOAddr[4:0]),
                              .writeRegDB_D(coprocessorIOAddr[4:0]),
                              .weDB_D(coprocessorIOControl[0]),
                              .csrAddrDB_D(coprocessorIOAddr[11:0]),
                              .csrDB_D(coprocessorIOControl[3]));

	 flopr #(333) ID_EX (.clk(clk),
	                     .reset(reset),
								.d({controlMux, qIF_ID[95:32], signImm_D, csrRead_D,
                            readData1_D, readData2_D}), // Preguntar sobre este ultimo
								.q(qID_EX));
                                       
    execute #(N) EXECUTE(.AluSrc(qID_EX[332]),  // AluSrc
                         .AluControl(qID_EX[331:328]), // AluControl
                         .PC_E(qID_EX[319:256]),  // IM_addr
                         .PC4_E(PC_4), // Preguntar origen de registro
                         .regSel1(regSel[1]),
                         .signImm_E(qID_EX[255:192]),  // sign_Imm_D
                         .readData1_E(qID_EX[127:64]), 
                         .readData2_E(qID_EX[63:0]), 
                         .PCBranch_E(PCBranch_E), 
                         .aluResult_E(DM_addr),
                         .writeData_E(writeData_E),
                         .wArith(wArith),
                         .zero_E(zero_E),
                         .overflow_E(overflow_E),
                         .sign_E(sign_E),
                         .aluSelect(aluSelect),
                         .CSRRead_E(qID_EX[191:128]),
                         .result1_Atom(aluResultAtom1_E));

	 flopr #(331) EX_MEM (.clk(clk),
                         .reset(reset), 
                         .d({qID_EX[327:320], qID_EX[63:0], PCBranch_E, PC_4, // Agregar como input al decode
                             DM_addr, aluResultAtom1_E, zero_E, overflow_E, sign_E}),
                         .q(qEX_MEM));	
    
    except_E eC_E (.DM_addr(qEX_MEM[130:67]),
                   .memOp({qEX_MEM[325], qEX_MEM[326]}),  //{memWrite, memRead[0]}
                   .memWidth(memWidth),
                   .exceptSignal(exceptSignal_E));

    memory #(N) MEMORY(.Branch_E(qEX_MEM[330:328]),  // Branch
                       .zero_E(qEX_MEM[2]),
                       .sign_E(qEX_MEM[0]),
                       .overflow_E(qEX_MEM[1]),
                       .PCSrc_W(PCSrc),  // Output para Fetch, no va para el registro
                       .DM_readData_E(DM_readData),  // Cambiar por readData2, DM_readData
                       .memWidth(memWidth),
                       .signedRead(qEX_MEM[327]),  //memRead[1]
                       .byteOffset(qEX_MEM[69:67]),
                       .readDataMasked_M(readDataMasked_M));

    assign DM_writeEnable = qEX_MEM[325]; // memWrite;
    assign DM_readEnable = qEX_MEM[326]; // memRead[0];
    assign DM_writeData = qEX_MEM[322:259]; //readData2_D;  // Cambiar por ID_EX
    assign memWidth_M = memWidth;

    assign CSR_addr = qIF_ID[31:20];
    assign CSR_WriteEnable = csrWriteEnable;
    assign csrIn = qEX_MEM[66:3]; // aluResultAtom1_E;

	 flopr #(130) MEM_WB (.clk(clk),
                         .reset(reset), 
                         .d({qEX_MEM[324:323], qEX_MEM[130:67], readDataMasked_M}),
                         .q(qMEM_WB));

    writeback #(N) WRITEBACK(.aluResult_W(qMEM_WB[127:64]), 
                             .DM_readData_W(qMEM_WB[63:0]), 
                             .memtoReg(qMEM_WB[128]),   // memtoReg
                             .writeData3_W(writeData3));

    assign breakSrc = {exceptSignal_E[6], exceptSignal_F[3]};
endmodule
