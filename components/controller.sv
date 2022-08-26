// CONTROLLER

module controller(input logic [6:0] instr, funct7,
				  input logic [2:0] funct3,
				  output logic [3:0] AluControl,						
				  output logic regWrite, AluSrc, memtoReg, memRead, 
				  output logic memWrite, Branch);
											
	logic [1:0] AluOp_s;
											
	maindec decPpal (.Op(instr), 
					.ALUSrc(AluSrc), 
					.MemtoReg(memtoReg), 
					.RegWrite(regWrite), 
					.MemRead(memRead), 
					.MemWrite(memWrite), 
					.Branch(Branch), 
					.ALUOp(AluOp_s));			
								
	aludec decAlu (.funct3(funct3), 
				   .funct7(funct7),
				   .aluop(AluOp_s), 
				   .alucontrol(AluControl));
			
endmodule
