// Etapa: WRITEBACK

module writeback #(parameter N = 64)
					(input logic [N-1:0] aluResult_W, DM_readData_W,
					input logic memtoReg,
					output logic [N-1:0] writeData3_W);					

	assign writeData3_W = memtoReg ? DM_readData_W : aluResult_W;
	
endmodule