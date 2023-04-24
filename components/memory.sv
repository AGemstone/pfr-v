module memory #(parameter N=64) (
    input logic[2:0] Branch_E,
    input logic zero_E,
    input logic sign_E,
    input logic overflow_E,
    output logic PCSrc_W,

    input logic[N-1:0] DM_readData_E,
    input logic[2:0] memWidth,
    input logic signedRead,
    input logic[2:0] byteOffset,
    output logic[N-1:0] readDataMasked_M);

    branching BRANCH(.Branch_E(Branch_E),
                    .zero(zero_E),
                    .sign(sign_E),
                    .overflow(overflow_E),
                    .PCSrc_W(PCSrc_W));

    memReadMask MEMREAD_MASK(.DM_readData_E(DM_readData_E),
                             .memWidth(memWidth),
                             .signedRead(signedRead),
                             .memOffset(byteOffset),
                             .readDataMasked_M(readDataMasked_M));
    
endmodule