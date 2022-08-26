// DATAPATH

module datapath #(parameter N = 64)
                    (input logic reset, clk,							
                    input logic AluSrc,
                    input logic [3:0] AluControl,
                    input logic	Branch,
                    input logic memRead,
                    input logic memWrite,
                    input logic regWrite,	
                    input logic memtoReg,
                    input logic [31:0] IM_readData,
                    input logic [N-1:0] DM_readData,
                    output logic [N-1:0] IM_addr, DM_addr, DM_writeData,
                    output logic DM_writeEnable, DM_readEnable ,
                    output logic Zero_Flag,
                    output logic [N-1:0] PCBranch_db,
                    output logic[1:0] fwA_db,fwB_db,
                    output logic hazard,
                    
                    output logic [16:0] instr);
                    
    logic PCSrc;
    
    logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, writeData3; 
    logic [N-1:0] signImm_D, readData1_D, readData2_D;
    logic zero_E;
    logic PCEnable, ControlEnable, IF_ID_writeEnable;
    logic [95:0] qIF_ID;
    logic [280:0] qID_EX;
    logic [202:0] qEX_MEM;
    logic [134:0] qMEM_WB;
    logic [1:0] fwA, fwB;
    logic [4:0] rs1, rs2;
    logic [10:0] controlMux;
    logic [N-1:0] fwA_out,fwB_out;

    assign controlMux = ControlEnable ? 
                        {AluSrc, AluControl, Branch, memRead, memWrite, 
                         regWrite, memtoReg} :
                        'b0;

    fetch #(64) FETCH (.PCSrc_F(PCSrc),
                       .clk(clk),
                       .reset(reset),
                       .PCEnable(PCEnable),
                       .PCBranch_F(qEX_MEM[197:134]),
                       .imem_addr_F(IM_addr));								
    
    flopre #(96) IF_ID (.clk(clk),
                        .enable(IF_ID_writeEnable),
                        .reset(reset), 
                        .d({IM_addr, IM_readData}),
                        .q(qIF_ID));
    
    decode #(64) DECODE(.regWrite_D(qMEM_WB[134]),
                        .clk(clk),
                        .writeData3_D(writeData3),
                        .instr_D(qIF_ID[31:0]),
                        .signImm_D(signImm_D), 
                        .readData1_D(readData1_D),
                        .readData2_D(readData2_D),
                        .wa3_D(qMEM_WB[4:0]));	
                                                                                                   
    flopr #(281) ID_EX (.clk(clk),
                        .reset(reset), 
                        .d({controlMux, qIF_ID[95:32], readData1_D, readData2_D,
                            signImm_D, qIF_ID[24:20], qIF_ID[19:15], 
                            qIF_ID[11:7]}),
                        .q(qID_EX));	
                                       
    execute #(64) EXECUTE (.AluSrc(qID_EX[280]),
                           .AluControl(qID_EX[279:276]),
                           .PC_E(qID_EX[260:197]), 
                           .signImm_E(qID_EX[196:133]), 
                           .readData1_E(fwA_out), 
                           .readData2_E(fwB_out), 
                           .PCBranch_E(PCBranch_E), 
                           .aluResult_E(aluResult_E), 
                           .writeData_E(writeData_E), 
                           .zero_E(zero_E));					
                                    
    flopr 	#(203)	EX_MEM 	(.clk(clk),
                             .reset(reset), 
                             .d({qID_EX[265:261], PCBranch_E, 
                                 zero_E, aluResult_E, writeData_E, qID_EX[4:0]}),
                             .q(qEX_MEM));	
    
                                        
    memory				MEMORY	(.Branch_W(qEX_MEM[202]), 
                                 .zero_W(qEX_MEM[133]), 
                                 .PCSrc_W(PCSrc));

    mux3 FWA (.s(fwA),
              .d0(qID_EX[132:69]),
              .d1(writeData3),
              .d2(qEX_MEM[132:69]),
              .y(fwA_out));

    mux3 FWB (.s(fwB),
             .d0(qID_EX[68:5]),
             .d1(writeData3),
             .d2(qEX_MEM[132:69]),
             .y(fwB_out));

    forwarding fwd (.EX_MEM_RegWrite(qEX_MEM[199]), 
                    .MEM_WB_RegWrite(qMEM_WB[134]),
                    .EX_MEM_RegisterRd(qEX_MEM[4:0]),
                    .MEM_WB_RegisterRd(qMEM_WB[4:0]),
                    .ID_EX_RegisterRs1(qID_EX[9:5]), 
                    .ID_EX_RegisterRs2(qID_EX[14:10]),
                    .fwA(fwA), 
                    .fwB(fwB));

    hazard hdu (.ID_EX_MemRead(qID_EX[264]),
                .ID_EX_RegisterRd(qID_EX[4:0]), 
                .IF_ID_RegisterRs1(rs1), 
                .IF_ID_RegisterRs2(rs2),
                .ControlEnable(ControlEnable),
                .PCEnable(PCEnable),
                .IF_ID_writeEnable(IF_ID_writeEnable)
                );
    
    // Salida de señales a Data Memory
    assign DM_writeData = qEX_MEM[68:5];
    assign DM_addr = qEX_MEM[132:69];
    
    // Salida de señales de control:
    assign DM_writeEnable = qEX_MEM[200];
    assign DM_readEnable = qEX_MEM[201];
    
    flopr 	#(135)	MEM_WB 	(.clk(clk),
                             .reset(reset), 
                             .d({qEX_MEM[199:198], qEX_MEM[132:69],	DM_readData, 
                                 qEX_MEM[4:0]}),
                             .q(qMEM_WB));
        
    
    writeback #(64) 	WRITEBACK (.aluResult_W(qMEM_WB[132:69]), 
                                   .DM_readData_W(qMEM_WB[68:5]), 
                                   .memtoReg(qMEM_WB[133]), 
                                   .writeData3_W(writeData3));		
    
    assign Zero_Flag = qEX_MEM[133];
    assign PCBranch_db = IM_addr;
    assign fwA_db = fwA;
    assign fwB_db = fwB;
    assign hazard = ControlEnable | PCEnable | IF_ID_writeEnable;
    assign instr = {qIF_ID[31:25], qIF_ID[14:12], qIF_ID[6:0]};

endmodule
