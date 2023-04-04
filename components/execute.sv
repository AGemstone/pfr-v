module execute #(
    parameter N = 64
) (
    input logic [N-1: 0] PC_E, readData1_E, readData2_E, signImm_E,
    input logic [N-1: 0] CSRRead_E,
    input logic AluSrc, regSel1, wArith, aluSelect,
    input logic[3:0] AluControl,
    output logic [N-1: 0] writeData_E, aluResult_E, PCBranch_E, PC4_E,
    output logic [N-1: 0] result1_Atom,
    output logic zero_E, overflow_E, sign_E
);
    logic[N-1: 0] readData1, readData2, signedImm_PC, aluResult;
    logic[N-1: 0] aluResultNormal, aluResultAtomic;

    // alternative to using a mux here is add another alu
    alu #(N) alu(.a(wArith ? {{32'b0}, readData1[31:0]} : readData1), 
                 .b(wArith ? {{32'b0}, readData2[31:0]} : readData2),
                 .ALUControl(AluControl),
                 .zero(zero_E),
                 .overflow(overflow_E),
                 .sign(sign_E),
                 .wArith(wArith),
                 .result(aluResult));
    
    atom_alu aluA(.a(AluSrc ? signImm_E : readData1_E),
                  .b(CSRRead_E),
                  .ALUControl(AluControl),
                  .result0(aluResultAtomic),
                  .result1(result1_Atom));

    assign aluResultNormal = wArith ? 
                            {{32{aluResult[31]}}, aluResult[(N/2)-1:0]} :
                            aluResult;
    assign aluResult_E = aluSelect ? aluResultAtomic : aluResultNormal;
    
    assign writeData_E = readData2_E;
    assign readData1 = regSel1 ? PC_E : readData1_E;
    assign readData2 = AluSrc ? signImm_E : readData2_E;
    assign signedImm_PC = (signImm_E << 1);
    assign PCBranch_E  = AluSrc ? {signImm_E[N-1:1],1'b0} : signedImm_PC + PC_E;
    assign PC4_E = PC_E + 'h4;
    
endmodule