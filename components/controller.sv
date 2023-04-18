// CONTROLLER

module controller(input logic[6:0] instr, 
                  input logic coprocessorStall,
                  input logic[11:0] funct12,
                  input logic[2:0] funct3,
                  input logic[1:0] privMode,
                  output logic[3:0] AluControl,
                  output logic[2:0] exceptSignal_D,		
                  output logic[1:0] regSel, memRead, 
                  output logic AluSrc, regWrite, memtoReg, memWrite, wArith,
                  output logic csrWriteEnable, trapReturn,
                  output logic breakSrc, aluSelect,
                  output logic[2:0] Branch, memWidth);
                                            
    logic[1:0] AluOp_s;
    logic[3:0] aluControlNormal, aluControlAtomic;
    

    // Might be a good idea to split maindec at this point
    // Privileged vs unprivileged
    maindec decPpal (.Op(instr),
                     .privMode(privMode),
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
                     .memWidth(memWidth),
                     .trapReturn(trapReturn),
                     .csrWriteEnable(csrWriteEnable),
                     .exceptSignal(exceptSignal_D),
                     .aluSelect(aluSelect),
                     .coprocessorStall(coprocessorStall),
                     .ALUOp(AluOp_s));
                                
    aludec decAlu (.funct3(funct3), 
                   .funct7(funct12[11:5]),
                   .aluop(AluOp_s), 
                   .alucontrol(aluControlNormal));
    
    aludec_atomic decAluAtomic (.funct3(funct3), 
                                .funct5(funct12[11:7]),
                                .aluop(AluOp_s), 
                                .alucontrol(aluControlAtomic));

    assign AluControl = aluSelect ? aluControlAtomic : aluControlNormal;
    assign breakSrc = exceptSignal_D[0];
endmodule
