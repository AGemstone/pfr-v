module memReadMask #(parameter N = 64) (
    input logic[N-1:0] DM_RD,
    input logic readOp,
    input logic[2:0] memWidth, memOffset,
    output logic[N-1:0] readData_M);

    logic[N-1:0] readMask, DM_RD_shifted;
    assign DM_RD_shifted = DM_RD >> {memOffset, 3'b0};
    assign readMask = {{32{memWidth[2]}}, {16{memWidth[1]}}, {8{memWidth[0]}}, {8'hff}};
    assign readData_M = readOp ? 
                        (memWidth[2] ? 
                            DM_RD_shifted :
                                (memWidth[1] ? 
                                {{32{DM_RD_shifted[31]}}, DM_RD_shifted[31:0]} :
                                    (memWidth[0] ? 
                                    {{48{DM_RD_shifted[15]}}, DM_RD_shifted[15:0]} : 
                                    {{56{DM_RD_shifted[7]}}, DM_RD_shifted[7:0]}
                                    )
                                )
                            ) : 
                        readMask & DM_RD_shifted;
endmodule