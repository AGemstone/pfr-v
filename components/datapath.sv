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
                    output logic [16:0] instr);
                    
    logic PCSrc;
    
    logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, writeData3; 
    logic [N-1:0] signImm_D, readData1_D, readData2_D;
    logic zero_E;

    fetch #(64) FETCH (.PCSrc_F(PCSrc),
                       .clk(clk),
                       .reset(reset),
                       .PCBranch_F(PCBranch_E),
                       .imem_addr_F(IM_addr));								
    
    decode #(64) DECODE(.regWrite_D(regWrite),
                        .clk(clk),
                        .writeData3_D(writeData3),
                        .instr_D(IM_readData),
                        .signImm_D(signImm_D), 
                        .readData1_D(readData1_D),
                        .readData2_D(readData2_D));	
                                       
    execute #(64) EXECUTE (.AluSrc(AluSrc),
                           .AluControl(AluControl),
                           .PC_E(IM_addr), 
                           .signImm_E(signImm_D), 
                           .readData1_E(readData1_D), 
                           .readData2_E(readData2_D), 
                           .PCBranch_E(PCBranch_E), 
                           .aluResult_E(DM_addr), 
                           .writeData_E(DM_writeData), 
                           .zero_E(zero_E));					
                                                                   
    memory	MEMORY	(.Branch_W(Branch), 
                     .zero_W(zero_E), 
                     .PCSrc_W(PCSrc));


    // Salida de señales de control:
    assign DM_writeEnable = memWrite;
    assign DM_readEnable = memRead;
        
    writeback #(64) WRITEBACK (.aluResult_W(DM_addr), 
                               .DM_readData_W(DM_readData), 
                               .memtoReg(memtoReg), 
                               .writeData3_W(writeData3));		
    
    assign Zero_Flag = zero_E;
    assign instr = {IM_readData[31:25], IM_readData[14:12], IM_readData[6:0]};
    

endmodule
