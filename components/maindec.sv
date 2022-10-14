module maindec (
    input logic[6:0] Op,
    input logic[2:0] funct3,
    output logic[1:0] regSel, MemRead,
    output logic ALUSrc, MemtoReg, RegWrite, MemWrite, w_arith,
    output logic[2:0] Branch, memMask,
    output logic[1:0] ALUOp
);
    logic [16:0] outputSignal; 
    always_comb
	    if(Op == 7'b1100011) begin
            // beq 
            if(funct3 == 3'b000)
                outputSignal = 'b0_00_000_00_0_000_001_01;
            // bne
            else if(funct3 == 3'b001)
                outputSignal = 'b0_00_000_00_0_000_011_01;
            // blt
            else if(funct3 == 3'b100)
                outputSignal = 'b0_00_000_00_0_000_101_01;
            // bge
            else if(funct3 == 3'b101)
                outputSignal = 'b0_00_000_00_0_000_100_01;
            // bltu
            else if(funct3 == 3'b110)
                outputSignal = 'b0_00_000_00_0_000_110_01;
            // bgeu
            else if(funct3 == 3'b111)
                outputSignal = 'b0_00_000_00_0_000_010_01;
            else
                outputSignal = 'b0_00_000_00_0_000_000_01;
        end
        // R format
        else if(Op == 7'b0110011)
            outputSignal = 'b0_00_001_00_0_000_000_10;
        // R format (32bit)
        else if(Op == 7'b0111011)
            outputSignal = 'b1_00_001_00_0_000_000_10;
        // I format
        else if(Op == 7'b0010011)
            outputSignal = 'b0_00_101_00_0_000_000_11;
        // I format (32bit)
        else if(Op == 7'b0011011)
            outputSignal = 'b1_00_101_00_0_000_000_11;
        // loads
        else if(Op == 7'b0000011) begin
            if(funct3 == 3'b000)
                outputSignal = 'b0_00_111_11_0_000_000_00;
            else if (funct3 == 3'b100)
                outputSignal = 'b0_00_111_01_0_000_000_00;
            else if(funct3 == 3'b001) 
                outputSignal = 'b0_00_111_11_0_001_000_00;
            else if(funct3 == 3'b101)
                outputSignal = 'b0_00_111_01_0_001_000_00;
            else if(funct3 == 3'b010)
                outputSignal = 'b0_00_111_11_0_011_000_00;
            else if(funct3 == 3'b110)
                outputSignal = 'b0_00_111_01_0_011_000_00;
            else 
                outputSignal = 'b0_00_111_11_0_111_000_00;
        end
        // stores
        else if(Op == 7'b0100011) begin
            if(funct3 == 3'b000)
                outputSignal = 'b0_00_100_00_1_000_000_00;
            else if(funct3 == 3'b001)
                outputSignal = 'b0_00_100_00_1_001_000_00;
            else if(funct3 == 3'b010)
                outputSignal = 'b0_00_100_00_1_011_000_00;
            else 
                outputSignal = 'b0_00_100_00_1_111_000_00;
        end

        //LUI
        else if (Op == 'b0110111)  
            outputSignal = 'b0_01_101_00_0_000_000_00;
        
        //AUIPC
        else if (Op == 'b0010111)
            outputSignal = 'b0_10_101_00_0_000_000_00;
        
        //JAL or JALR
        else if (Op == 'b1101111 | Op == 'b1100111)   
            outputSignal = 'b0_00_001_00_0_000_111_01;

        else 
            outputSignal = 'b0;
    
    assign w_arith = outputSignal[16];
    //00: normal, 01: immediate, zero, 10: immediate, PC, 11: PC + 4
    assign regSel       = outputSignal[15:14];
    assign ALUSrc       = outputSignal[13];
    assign MemtoReg     = outputSignal[12];
    assign RegWrite     = outputSignal[11];
    // 00: no read, 01: read signed, 10: no read, 11:read unsigned
    assign MemRead      = outputSignal[10:9];
    assign MemWrite     = outputSignal[8];
    // 000: byte, 001: half, 011: word, 111: double
    assign memMask      = outputSignal[7:5];
    // 000: no branch, 
    // 001: branch if zero, 011: Branch if not zero
    // 101: Branch if LT, 100: Branch if GE
    // 110: Branch if LT, 010: Branch if GE (unsigned)
    // 111: branch unconditionally, the rest are undefined
    assign Branch       = outputSignal[4:2];
    assign ALUOp        = outputSignal[1:0];
    
endmodule