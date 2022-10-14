// ALU CONTROL DECODER

module aludec(input  logic [6:0] funct7, 
			  input logic [2:0] funct3,
			  input  logic [1:0]  aluop,  
			  output logic [3:0] alucontrol);  
		
	always_comb
		// loads or stores
		if (aluop == 2'b00) 
			alucontrol = 4'b0010;
		// Branches						
		else if (aluop == 2'b01) 
			alucontrol = 4'b0110;
		// R format
		else if ((aluop == 2'b10))
			// add
			if (funct7[5] == 1'b0 & funct3 == 3'b000)
				alucontrol = 4'b0010;	
			// sub
			else if (funct7[5] == 1'b1 & funct3 == 3'b000)
				alucontrol = 4'b0110;	
			// and
			else if (funct7[5] == 1'b0 & funct3 == 3'b111)
				alucontrol = 4'b0000;	
			// or
			else if (funct7[5] == 1'b0 & funct3 == 3'b110)
				alucontrol = 4'b0001;
			// xor
			else if (funct7[5] == 1'b0 & funct3 == 3'b100)
				alucontrol = 4'b1001;
			// slt
			else if (funct7[5] == 1'b0 & funct3 == 3'b010)
				alucontrol = 4'b1110;
			// sltu
			else if (funct7[5] == 1'b0 & funct3 == 3'b011)
				alucontrol = 4'b1010;
			else 
				alucontrol = 4'b1111;
		// I format
		else if ((aluop == 2'b11))
			// addi
			if (funct3 == 3'b000)
				alucontrol = 4'b0010;
			// andi
			else if (funct3 == 3'b111)
				alucontrol = 4'b0000;	
			// ori
			else if (funct3 == 3'b110)
				alucontrol = 4'b0001;
			// xori
			else if (funct3 == 3'b100)
				alucontrol = 4'b1001;
			// slti
			else if (funct3 == 3'b010)
				alucontrol = 4'b1110;
			// sltiu
			else if (funct3 == 3'b011)
				alucontrol = 4'b1010;
			
			// slli
			else if (funct3 == 3'b001)
				alucontrol = 4'b0111;
			// srli
			else if (funct7[5] == 1'b0 & funct3 == 3'b101)
				alucontrol = 4'b0011;
			// srai
			else if (funct7[5] == 1'b1 & funct3 == 3'b101)
				alucontrol = 4'b1011;
				
			else 
				alucontrol = 4'b1111;
		else 
			alucontrol = 4'b1111;
endmodule
