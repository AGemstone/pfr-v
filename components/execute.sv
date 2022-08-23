module execute #(
    parameter N = 64
) (
    input logic [N-1: 0] PC_E, readData1_E, readData2_E, signImm_E,
    input logic AluSrc,
    input logic[3:0] AluControl,
    output logic [N-1: 0] writeData_E, aluResult_E, PCBranch_E,
    output logic zero_E
);
    logic[N-1: 0]aluOut, mux_out, shift_out,PCBranch;
    logic zero;
    mux2 #(N) mux(
        .s(AluSrc),
        .d0(readData2_E),
        .d1(signImm_E),
        .y(mux_out)
    );
    sl2 #(N) shift(
        .a(signImm_E),
        .y(shift_out)

    );
    adder #(N) adder(
        .a(shift_out),
        .b(PC_E),
        .y(PCBranch)
    );
    alu #(N) alu(.a(readData1_E), 
    .b(mux_out),
    .ALUControl(AluControl),
    .zero(zero),
    .result(aluOut));

    assign writeData_E = readData2_E;
    assign aluResult_E = aluOut;
    assign PCBranch_E  = PCBranch;
    assign zero_E      = zero;

    
endmodule