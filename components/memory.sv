// Etapa: MEMORY

module memory 	(input logic[2:0] Branch_W,
				 input logic zero_W,					
				 output logic PCSrc_W);
					
	assign PCSrc_W = Branch_W[0] & ((zero_W & ~Branch_W[1]) | (~zero_W & Branch_W[1]));
	
endmodule