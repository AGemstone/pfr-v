module execute_tb();
    logic AluSrc, zero_E;
    logic [3:0] AluControl;
    logic [63:0] PC_E, signImm_E, readData1_E, readData2_E;
    logic [63:0] PCBranch_E, aluResult_E, writeData_E;

    execute dut(PC_E, signImm_E, readData1_E, readData2_E, AluSrc, AluControl, 
                zero_E, PCBranch_E, aluResult_E, writeData_E);

    initial begin
    signImm_E = 0; PC_E = 0; AluSrc = 0;
    //add 4 test for branch
    #10; assert(PCBranch_E == 0);
    //two negatives
    readData1_E = -1; readData2_E = -2;
    AluControl = 4'b0000;#10; assert(aluResult_E == -2); assert(zero_E == 0);
    AluControl = 4'b0001;#10; assert(aluResult_E == -1); assert(zero_E == 0);
    AluControl = 4'b0010;#10; assert(aluResult_E == -3); assert(zero_E == 0);
    AluControl = 4'b0110;#10; assert(aluResult_E == 1); assert(zero_E == 0);
    AluControl = 4'b0111;#10; assert(aluResult_E == -2); assert(zero_E == 0);
    AluControl = 4'b1100;#10; assert(aluResult_E == 0); assert(zero_E == 1);
    assert(writeData_E == -2);
    // one negative one positive
    readData1_E = 1; readData2_E = -2; 
    AluControl = 4'b0000;#10; assert(aluResult_E == 0); assert(zero_E == 1);
    AluControl = 4'b0001;#10; assert(aluResult_E == -1); assert(zero_E == 0);
    AluControl = 4'b0010;#10; assert(aluResult_E == -1); assert(zero_E == 0);
    AluControl = 4'b0110;#10; assert(aluResult_E == 3); assert(zero_E == 0);
    AluControl = 4'b0111;#10; assert(aluResult_E == -2); assert(zero_E == 0);
    AluControl = 4'b1100;#10; assert(aluResult_E == 0); assert(zero_E == 1);
    assert(writeData_E == -2);
    //two positives
    readData1_E = 1; readData2_E = 1;
    AluControl = 4'b0000;#10; assert(aluResult_E == 1); assert(zero_E == 0);
    AluControl = 4'b0001;#10; assert(aluResult_E == 1); assert(zero_E == 0);
    AluControl = 4'b0010;#10; assert(aluResult_E == 2); assert(zero_E == 0);
    AluControl = 4'b0110;#10; assert(aluResult_E == 0); assert(zero_E == 1);
    AluControl = 4'b0111;#10; assert(aluResult_E == 1); assert(zero_E == 0);
    AluControl = 4'b1100;#10; assert(aluResult_E == -2); assert(zero_E == 0);
    assert(writeData_E == 1);
    // signImm test
    readData1_E = 1; signImm_E = 1; AluSrc = 0;
    AluControl = 4'b0000;#10; assert(aluResult_E == 1); assert(zero_E == 0);
    AluControl = 4'b0001;#10; assert(aluResult_E == 1); assert(zero_E == 0);
    AluControl = 4'b0010;#10; assert(aluResult_E == 2); assert(zero_E == 0);
    AluControl = 4'b0110;#10; assert(aluResult_E == 0); assert(zero_E == 1);
    AluControl = 4'b0111;#10; assert(aluResult_E == 1); assert(zero_E == 0);
    AluControl = 4'b1100;#10; assert(aluResult_E == -2); assert(zero_E == 0);
    assert(PCBranch_E == 4);
    end
endmodule