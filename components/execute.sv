module execute #(
    parameter N = 64
) (
    input logic [N-1: 0] PC_E, readData1_E, readData2_E, signImm_E,
    input logic AluSrc, regSel1,
    input logic[3:0] AluControl,
    output logic [N-1: 0] writeData_E, aluResult_E, PCBranch_E,
    output logic zero_E
);
    logic[N-1: 0] readData1, readData2, signedImm_PC,rea;


    alu #(N) alu(.a(readData1), 
                 .b(readData2),
                 .ALUControl(AluControl),
                 .zero(zero_E),
                 .result(aluResult_E));

    assign writeData_E = readData2_E;
    assign readData1 = regSel1 ? PC_E : readData1_E;
    assign readData2 = AluSrc ? signImm_E : readData2_E;
    assign signedImm_PC = (signImm_E << 1);
    assign PCBranch_E  = signedImm_PC + PC_E;

    
endmodule