module maindec (
    input logic[10:0] Op,
    output logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, 
    output logic BranchZero,
    output logic[1: 0] ALUOp
);
    logic [9:0] signal; // order is the same as outputs
    always_comb
		// CBZ
	    if(Op[10: 3] == 8'b101_1010_0)
            signal = 10'b1_100000_1_01;
        // CBNZ
        else if(Op[10: 3] == 8'b101_1010_1)
            signal = 10'b0_100000_1_01;
        // R format
        else if(Op == 11'b101_0101_0000 |
                Op == 11'b100_0101_0000 |
                Op == 11'b110_0101_1000 |
                Op == 11'b100_0101_1000)
            signal = 10'b0_000100_0_10;
        // I format
        else if(Op[10:1] == 10'b1001_0001_00 |
                Op[10:1] == 10'b1101_0001_00)
            signal = 10'b0_010100_0_11;
        // LDUR
        else if(Op == 11'b111_1100_0010)
            signal = 10'b0_011110_0_00;
        // STUR
        else if(Op == 11'b111_1100_0000)
            signal = 10'b0_110001_0_00;
        else 
            signal = 10'b0;
    assign BranchZero   = signal[9] ;
    assign Reg2Loc      = signal[8];
    assign ALUSrc       = signal[7];
    assign MemtoReg     = signal[6];
    assign RegWrite     = signal[5];
    assign MemRead      = signal[4];
    assign MemWrite     = signal[3];
    assign Branch       = signal[2];
    assign ALUOp        = signal[1:0];
    
endmodule