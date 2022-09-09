// CONTROLLER

module controller(input logic[6:0] instr, funct7,
                  input logic[2:0] funct3,
                  output logic[3:0] AluControl,				
                  output logic[1:0] regSel,
                  output logic AluSrc, regWrite, memtoReg, memRead, memWrite, 
                  output logic[2:0] Branch);
                                            
    logic [1:0] AluOp_s;
                                            
    maindec decPpal (.Op(instr),
                     .funct3(funct3),
                     .ALUSrc(AluSrc), 
                     .MemtoReg(memtoReg), 
                     .RegWrite(regWrite), 
                     .MemRead(memRead), 
                     .MemWrite(memWrite), 
                     .Branch(Branch),
                     .regSel(regSel),
                     .ALUOp(AluOp_s));			
                                
    aludec decAlu (.funct3(funct3), 
                   .funct7(funct7),
                   .aluop(AluOp_s), 
                   .alucontrol(AluControl));
            
endmodule
