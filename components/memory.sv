// Etapa: MEMORY

module memory 	(input logic Branch_W,
				 input logic zero_W,					
				 output logic PCSrc_W);
					
	assign PCSrc_W = Branch_W & zero_W;
	
endmodule