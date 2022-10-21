module execute #(
    parameter N = 64
) (
    input logic [N-1: 0] PC_E, readData1_E, readData2_E, signImm_E,
    input logic AluSrc, regSel1, w_arith,
    input logic[3:0] AluControl,
    output logic [N-1: 0] writeData_E, aluResult_E, PCBranch_E, PC4_E,
    output logic zero_E, overflow_E, sign_E
);
    logic[N-1: 0] readData1, readData2, signedImm_PC, aluResult;

    // alternative is add a second alu
    alu #(N) alu(.a(w_arith ? {{32'b0}, readData1[31:0]} : readData1), 
                 .b(w_arith ? {{32'b0}, readData2[31:0]} : readData2),
                 .ALUControl(AluControl),
                 .zero(zero_E),
                 .overflow(overflow_E),
                 .sign(sign_E),
                 .w_arith(w_arith),
                 .result(aluResult));

    assign aluResult_E = w_arith ? 
                        {{32{aluResult[31]}}, aluResult[(N/2)-1:0]} :
                        aluResult;
    
    assign writeData_E = readData2_E;
    assign readData1 = regSel1 ? PC_E : readData1_E;
    assign readData2 = AluSrc ? signImm_E : readData2_E;
    assign signedImm_PC = (signImm_E << 1);
    assign PCBranch_E  = signedImm_PC + PC_E;
    assign PC4_E = PC_E + 'h4;
    
endmodule