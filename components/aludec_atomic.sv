module aludec_atomic(input logic [4:0] funct5, 
			         input logic [2:0] funct3,
			         input logic [1:0] aluop,  
			         output logic [3:0] alucontrol);  
		
	always_comb
    // LR / SC
    if (aluop == 'b00)
        alucontrol = 4'b1111;
    // AMO operations
    else if (aluop == 'b01)
        alucontrol = 4'b1111;
    // CSRRX
    else if (aluop == 'b10)
        if(funct3 == 3'b001 | funct3 == 3'b101)
            alucontrol = 4'b0000;
        else if(funct3 == 3'b010 | funct3 == 3'b110)
            alucontrol = 4'b0001;
        else if(funct3 == 3'b011 | funct3 == 3'b111)
            alucontrol = 4'b0011;
        else 
        alucontrol = 4'b1111;
    // Reserved
    else
        alucontrol = 4'b1111;
endmodule