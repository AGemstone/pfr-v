// Etapa: WRITEBACK

module writeback #(parameter N = 64)
					(input logic [N-1:0] aluResult_W, // DM_readData_W,
					input logic memtoReg,
					output logic [N-1:0] writeData3_W,
					
					input logic[N-1:0] DM_readData_W,
               input logic[2:0] memWidth,
               input logic signedRead,
               input logic[2:0] byteOffset);
	
	logic[N-1: 0] readDataMasked_M;
		
	memReadMask MEMREAD_MASK(.DM_readData_E(DM_readData_W),
                            .memWidth(memWidth),
                            .signedRead(signedRead),
                            .memOffset(byteOffset),
                            .readDataMasked_M(readDataMasked_M));

	assign writeData3_W = memtoReg ? readDataMasked_M : aluResult_W;
	
endmodule