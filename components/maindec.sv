module maindec (
    input logic coprocessorStall,
    input logic[6:0] Op,
    input logic[2:0] funct3,
    input logic[11:0] funct12,
    input logic[1:0] privMode, 
    output logic[1:0] regSel, MemRead,
    output logic ALUSrc, MemtoReg, RegWrite, MemWrite, wArith, aluSelect,
    output logic csrWriteEnable, trapReturn,
    output logic[2:0] Branch, memWidth, exceptSignal,
    output logic[1:0] ALUOp
);
    logic [22:0] outputSignal;
    
    logic [2:0] subPriv_CSRAddr;
    logic csrPrivCheck;
    assign subPriv_CSRAddr = privMode - funct12[9:8];
    assign csrPrivCheck = ~subPriv_CSRAddr[2];

    always_comb
        // If coprocessor is soft resetting or injecting a fault
        if (coprocessorStall)
            outputSignal = 'b0;
        else begin
	    if (Op == 7'b1100011) begin
            // beq 
            if (funct3 == 3'b000)
                outputSignal = 'b000_000_0_00_000_00_0_000_001_01;
            // bne
            else if (funct3 == 3'b001)
                outputSignal = 'b000_000_0_00_000_00_0_000_011_01;
            // blt
            else if (funct3 == 3'b100)
                outputSignal = 'b000_000_0_00_000_00_0_000_101_01;
            // bge
            else if (funct3 == 3'b101)
                outputSignal = 'b000_000_0_00_000_00_0_000_100_01;
            // bltu
            else if (funct3 == 3'b110)
                outputSignal = 'b000_000_0_00_000_00_0_000_110_01;
            // bgeu
            else if (funct3 == 3'b111)
                outputSignal = 'b000_000_0_00_000_00_0_000_010_01;
            else
                outputSignal = 'b000_000_0_00_000_00_0_000_000_01;
        end
        // R format
        else if (Op == 7'b0110011)
            outputSignal = 'b000_000_0_00_001_00_0_000_000_10;

        // R format (32bit)
        else if (Op == 7'b0111011)
            outputSignal = 'b000_000_1_00_001_00_0_000_000_10;

        // I format
        else if (Op == 7'b0010011)
            outputSignal = 'b000_000_0_00_101_00_0_000_000_11;

        // I format (32bit)
        else if (Op == 7'b0011011)
            outputSignal = 'b000_000_1_00_101_00_0_000_000_11;

        // loads
        else if (Op == 7'b0000011) begin
            // lb
            if (funct3 == 3'b000)
                outputSignal = 'b000_000_0_00_111_11_0_000_000_00;
            // lbu
            else if (funct3 == 3'b100)
                outputSignal = 'b000_000_0_00_111_01_0_000_000_00;
            // lh
            else if(funct3 == 3'b001) 
                outputSignal = 'b000_000_0_00_111_11_0_001_000_00;
            // lhu
            else if(funct3 == 3'b101)
                outputSignal = 'b000_000_0_00_111_01_0_001_000_00;
            // lw
            else if(funct3 == 3'b010)
                outputSignal = 'b000_000_0_00_111_11_0_011_000_00;
            // lwu
            else if(funct3 == 3'b110)
                outputSignal = 'b000_000_0_00_111_01_0_011_000_00;
            // ld
            else 
                outputSignal = 'b000_000_0_00_111_11_0_111_000_00;
        end
        // stores
        else if (Op == 7'b0100011) begin
            if (funct3 == 3'b000)
                outputSignal = 'b000_000_0_00_100_00_1_000_000_00;
            else if (funct3 == 3'b001)
                outputSignal = 'b000_000_0_00_100_00_1_001_000_00;
            else if (funct3 == 3'b010)
                outputSignal = 'b000_000_0_00_100_00_1_011_000_00;
            else 
                outputSignal = 'b000_000_0_00_100_00_1_111_000_00;
        end

        // LUI
        else if (Op == 'b0110111)  
            outputSignal = 'b000_000_0_01_101_00_0_000_000_00;
        
        // AUIPC
        else if (Op == 'b0010111)
            outputSignal = 'b000_000_0_10_101_00_0_000_000_00;
        
        // JAL
        else if (Op == 'b1101111)   
            outputSignal = 'b000_000_0_00_001_00_0_000_111_01;
        // JALR
        else if (Op == 'b1100111)
            outputSignal = 'b000_000_0_00_101_00_0_000_111_01;
        // SYSTEM
        else if (Op == 'b1110011) begin
            if (funct3 == 3'b000) begin
                // 00100073 // ebreak
                if (funct12 == 'h001)
                    outputSignal = 'b000_001_0_00_000_00_0_000_000_00;
                // 00000073 // ecall
                else if (funct12 == 'h000)
                    outputSignal = 'b000_010_0_00_000_00_0_000_000_00;
                // 30200073 // mret
                else if (funct12 == 'h302)
                    outputSignal = 'b100_000_0_00_000_00_0_000_000_00;
                // same as illegal for now
                // 10200073 // sret
                // 10500073 // wfi
                else
                    outputSignal = 'b000_100_0_00_000_00_0_000_000_00;
            end
            // csrrx
            else if ((funct3 == 3'b001) |
                     (funct3 == 3'b010) |
                     (funct3 == 3'b011))
                outputSignal = 'b011_000_0_00_001_00_0_000_000_10;
            // csrrxi
            else if ((funct3 == 3'b101) | 
                     (funct3 == 3'b110) | 
                     (funct3 == 3'b111)) 
                outputSignal = 'b011_000_0_00_101_00_0_000_000_10;
            else 
                outputSignal = 'b000_100_0_00_000_00_0_000_000_00;
        end
        // FENCE
        else if(Op == 'b0001111)
            outputSignal = 'b000_000_0_00_000_00_0_000_000_00;
        // undefined / illegal instruction
        else 
            outputSignal = 'b000_100_0_00_000_00_0_000_000_00;
        end
    assign trapReturn = outputSignal[22];
    assign aluSelect = outputSignal[21];
    assign csrWriteEnable = outputSignal[20];
    //[2]: illegal, [1]:ecall, [0]: ebreak
    assign exceptSignal = outputSignal[19:17];
    assign wArith = outputSignal[16];
    //00: normal, 01: immediate, zero, 10: immediate, PC, 11: PC + 4
    assign regSel       = outputSignal[15:14];
    assign ALUSrc       = outputSignal[13];
    assign MemtoReg     = outputSignal[12];
    assign RegWrite     = outputSignal[11];
    // 00: no read, 01: read signed, 10: no read, 11:read unsigned
    assign MemRead      = outputSignal[10:9];
    assign MemWrite     = outputSignal[8];
    // 000: byte, 001: half, 011: word, 111: double
    assign memWidth      = outputSignal[7:5];
    // 000: No branch, 
    // 001: Branch if equal, 011: Branch if not equal
    // 101: Branch if LT, 100: Branch if GE
    // 110: Branch if LT, 010: Branch if GE (unsigned)
    // 111: Branch unconditionally, the rest are undefined
    assign Branch       = outputSignal[4:2];
    assign ALUOp        = outputSignal[1:0];
    
endmodule