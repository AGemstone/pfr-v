// module memory #(parameter N=64) (
//     input logic [N-1] readData, writeData, aluResult_E
//     input logic[2:0] extControl,
//     input logic memRead,
//     output logic[N-1] readData_M, writeData_M, aluResult_X
// );
//     // logic ext
//     // {{32{aluResult_E[31]}},aluResult_E};

//     // branching b(.Branch_W(Branch), 
//     //                  .zero_W(zero_E), 
//     //                  .PCSrc_W(PCSrc));

//     // memmask mask(.DM_RD(DM_readData),
//     //              .DM_WD(writeData_E),
//     //              .memMask(memMask),
//     //              .readData_M(Mask_readData),
//     //              .writeData_M(DM_writeData));
    
//     // ~memRead ? {{32{aluResult_E[31]}},aluResult_E} :
//     // () ;
    
// endmodule