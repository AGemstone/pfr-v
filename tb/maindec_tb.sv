module maindec_tb();
    logic [10:0] Op;
    logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch,BranchZero;
    logic [1:0] ALUOp;

    maindec dut(Op,Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
                Branch, BranchZero, ALUOp);
    initial begin
    //ldur test
    Op = 11'b111_1100_0010; #10;
    assert(Reg2Loc == 0 && ALUSrc == 1 && MemtoReg == 1 && RegWrite == 1 &&
            MemRead == 1 && MemWrite == 0 && Branch == 0 && BranchZero == 0 &&
            ALUOp == 2'b00);
    //stur test
    Op = 11'b111_1100_0000; #10;
    assert(Reg2Loc == 1 && ALUSrc == 1 && MemtoReg == 0 && RegWrite == 0 &&
            MemRead == 0 && MemWrite == 1 && Branch == 0 && BranchZero == 0 &&
            ALUOp == 2'b00);
    
    //rformat test
    Op = 11'b100_0101_1000; #10;
    assert(Reg2Loc == 0 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 1 &&
            MemRead == 0 && MemWrite == 0 && Branch == 0 && BranchZero == 0 &&
            ALUOp == 2'b10);
    Op = 11'b110_0101_1000; #10;
    assert(Reg2Loc == 0 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 1 &&
            MemRead == 0 && MemWrite == 0 && Branch == 0 && BranchZero == 0 &&
            ALUOp == 2'b10);
    Op = 11'b100_0101_0000; #10;
    assert(Reg2Loc == 0 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 1 &&
            MemRead == 0 && MemWrite == 0 && Branch == 0 && BranchZero == 0 &&
            ALUOp == 2'b10);
    Op = 11'b101_0101_0000; #10;
    assert(Reg2Loc == 0 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 1 &&
            MemRead == 0 && MemWrite == 0 && Branch == 0 && BranchZero == 0 &&
            ALUOp == 2'b10);


    //cbz test
    Op = 11'b101_1010_0_000; #10; 
    assert(Reg2Loc == 1 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 0 &&
            MemRead == 0 && MemWrite == 0 && Branch == 1 && BranchZero == 1 &&
            ALUOp == 2'b01);
    Op = 11'b101_1010_0_001; #10;
    assert(Reg2Loc == 1 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 0 &&
            MemRead == 0 && MemWrite == 0 && Branch == 1 && BranchZero == 1 &&
            ALUOp == 2'b01);
    Op = 11'b101_1010_0_010; #10;
    assert(Reg2Loc == 1 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 0 &&
            MemRead == 0 && MemWrite == 0 && Branch == 1 &&  BranchZero == 1 &&
            ALUOp == 2'b01);
    Op = 11'b101_1010_0_011; #10;
    assert(Reg2Loc == 1 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 0 &&
            MemRead == 0 && MemWrite == 0 && Branch == 1 && BranchZero == 1 &&
            ALUOp == 2'b01);
    Op = 11'b101_1010_0_100; #10;
    assert(Reg2Loc == 1 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 0 &&
            MemRead == 0 && MemWrite == 0 && Branch == 1 && BranchZero == 1 &&
            ALUOp == 2'b01);
    Op = 11'b101_1010_0_101; #10;
    assert(Reg2Loc == 1 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 0 &&
            MemRead == 0 && MemWrite == 0 && Branch == 1 && BranchZero == 1 &&
            ALUOp == 2'b01);
    Op = 11'b101_1010_0_110; #10;
    assert(Reg2Loc == 1 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 0 &&
            MemRead == 0 && MemWrite == 0 && Branch == 1 && BranchZero == 1 &&
            ALUOp == 2'b01);
    Op = 11'b101_1010_0_111; #10;
    assert(Reg2Loc == 1 && ALUSrc == 0 && MemtoReg == 0 && RegWrite == 0 &&
            MemRead == 0 && MemWrite == 0 && Branch == 1 && BranchZero == 1 &&
            ALUOp == 2'b01);
    Op = 11'b111_1111_1111; #10;
    end
endmodule