module maindec (
    input logic[6:0] Op,
    input logic[2:0] funct3,
    output logic[1:0] regSel, 
    output logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, 
    output logic[2:0] Branch, 
    output logic[1:0] ALUOp
);
    logic [11:0] outputSignal; 
    always_comb
	    if(Op == 7'b1100011)
            // beq 
            if(funct3 == 3'b000)
                outputSignal = 'b00_00000_001_01;
            //bne
            else if(funct3 == 3'b001)
                outputSignal = 'b00_00000_011_01;
            else
                outputSignal = 'b00_00000_000_01;
        // R format
        else if(Op == 7'b0110011)
            outputSignal = 'b00_00100_000_10;
        // I format
        else if(Op == 7'b0010011)
            outputSignal = 'b00_10100_000_11;
        // ld
        else if(Op == 7'b0000011)
            outputSignal = 'b00_11110_000_00;
        // sd
        else if(Op == 7'b0100011)
            outputSignal = 'b00_10001_000_00;

        //LUI
        else if (Op == 'b0110111)  
            outputSignal = 'b01_10100_000_00;
        
        //AUIPC
        else if (Op == 'b0010111)
            outputSignal = 'b10_10100_000_00;

        else 
            outputSignal = 'b0;

    //00: normal, 01: immediate, zero, 10: immediate, PC, 11:undef
    assign regSel       = outputSignal[11:10];
    assign ALUSrc       = outputSignal[9];
    assign MemtoReg     = outputSignal[8];
    assign RegWrite     = outputSignal[7];
    assign MemRead      = outputSignal[6];
    assign MemWrite     = outputSignal[5];
    // 000: no branch, 001: branch if zero, 011: Branch if not zero
    // 101: Branch if LT, 111: Branch if GE
    assign Branch       = outputSignal[4:2];
    assign ALUOp        = outputSignal[1:0];
    
endmodule