// CONTROLLER

module controller(input logic[6:0] instr, 
                  input logic[11:0] funct12,
                  input logic[2:0] funct3,
                  output logic[3:0] AluControl,
                  output logic[2:0] exceptSignal_D,		
                  output logic[1:0] regSel, memRead, 
                  output logic AluSrc, regWrite, memtoReg, memWrite, wArith,
                  output logic breakSrc,
                  output logic[2:0] Branch, memMask);
                                            
    logic[1:0] AluOp_s;
    
    maindec decPpal (.Op(instr),
                     .funct3(funct3),
                     .ALUSrc(AluSrc), 
                     .funct12(funct12),
                     .MemtoReg(memtoReg), 
                     .RegWrite(regWrite), 
                     .MemRead(memRead), 
                     .MemWrite(memWrite), 
                     .Branch(Branch),
                     .regSel(regSel),
                     .wArith(wArith),
                     .memMask(memMask),
                     .exceptSignal(exceptSignal_D),
                     .ALUOp(AluOp_s));
                                
    aludec decAlu (.funct3(funct3), 
                   .funct7(funct12[11:5]),
                   .aluop(AluOp_s), 
                   .alucontrol(AluControl));
    
    assign breakSrc = exceptSignal_D[0];
endmodule
