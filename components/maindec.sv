module maindec (
    input logic[6:0] Op,
    output logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, 
    output logic[1: 0] ALUOp
);
    logic [7:0] outputSignal; 
    always_comb
		// beq or bne
	    if(Op == 7'b1100011)
            outputSignal = 8'b00000_1_01;
        // R format
        else if(Op == 7'b0110011)
            outputSignal = 8'b00100_0_10;
        // I format
        else if(Op == 7'b0010011)
            outputSignal = 8'b10100_0_11;
        // ld
        else if(Op == 7'b0000011)
            outputSignal = 8'b11110_0_00;
        // sd
        else if(Op == 7'b0100011)
            outputSignal = 8'b10001_0_00;
        else 
            outputSignal = 8'b0;
    assign ALUSrc       = outputSignal[7];
    assign MemtoReg     = outputSignal[6];
    assign RegWrite     = outputSignal[5];
    assign MemRead      = outputSignal[4];
    assign MemWrite     = outputSignal[3];
    assign Branch       = outputSignal[2];
    assign ALUOp        = outputSignal[1:0];
    
endmodule