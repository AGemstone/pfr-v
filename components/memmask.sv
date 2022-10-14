module memmask #(parameter N = 64) (
    input logic[N-1:0] DM_RD, DM_WD,
    input logic readOp,
    input logic[2:0] memMask,
    output logic[N-1:0] readData_M, writeData_M
);
    logic[N-1:0] mask;
    assign mask = {{32{memMask[2]}}, {16{memMask[1]}}, {8{memMask[0]}}, {8'hff}};
    assign readData_M = readOp ? (memMask[2] ? DM_RD :
                                 (memMask[1] ? 
                                     {{32{DM_RD[31]}}, DM_RD[31:0]} :
                                     (memMask[0] ? 
                                         {{48{DM_RD[15]}}, DM_RD[15:0]} : 
                                         {{56{DM_RD[7]}}, DM_RD[7:0]}
                                     )
                                 )
                             ) : 
                             mask & DM_RD;
    assign writeData_M = mask & DM_WD;
endmodule