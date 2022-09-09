// ALU CONTROL DECODER

module aludec(input  logic [6:0] funct7, 
			  input logic [2:0] funct3,
			  input  logic [1:0]  aluop,  
			  output logic [3:0] alucontrol);  				
	always_comb
		// ld or sd
		if (aluop == 2'b00) 
			alucontrol = 4'b0010;						
		else if (aluop == 2'b01) 
			// beq or bne
			if (funct3 == 3'b000 | funct3 == 3'b001)
				alucontrol = 4'b0110;
			else  
				alucontrol = 4'b1111;
		else if ((aluop == 2'b10))
			// add
			if (funct7 == 7'b0000000 & funct3 == 3'b000)
				alucontrol = 4'b0010;	
			// sub
			else if (funct7 == 7'b0100000 & funct3 == 3'b000)
				alucontrol = 4'b0110;	
			// and
			else if (funct7 == 7'b0000000 & funct3 == 3'b111)
				alucontrol = 4'b0000;	
			// or
			else if (funct7 == 7'b0000000 & funct3 == 3'b110)
				alucontrol = 4'b0001;
			else 
				alucontrol = 4'b1111;
		else if ((aluop == 2'b11))
			// add
			if (funct3 == 3'b000)
				alucontrol = 4'b0010;
			// and
			else if (funct3 == 3'b111)
				alucontrol = 4'b0000;	
			// or
			else if (funct3 == 3'b110)
				alucontrol = 4'b0001;
			else 
				alucontrol = 4'b1111;
		else 
			alucontrol = 4'b1111;
endmodule
