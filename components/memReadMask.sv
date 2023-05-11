module memReadMask #(parameter N = 64) (
    input logic[N-1:0] DM_readData_E,
    input logic signedRead,
    input logic[2:0] memWidth, memOffset,
    output logic[N-1:0] readDataMasked_M);

    logic[N-1:0] readMask, DM_readData_shifted;
    logic[3:0] memOp;
    assign DM_readData_shifted = DM_readData_E >> {memOffset, 3'b0};
    // Always read at least a byte
    assign readMask = {{32{memWidth[2]}}, 
                       {16{memWidth[1]}}, 
                       {8{memWidth[0]}}, 
                       {8'hff}};

    
    assign memOp = {signedRead, memWidth};
    always_comb
    case (memOp)
        'b1_011 : readDataMasked_M = {{32{DM_readData_shifted[31]}}, DM_readData_shifted[31:0]};
        'b1_001 : readDataMasked_M = {{48{DM_readData_shifted[15]}}, DM_readData_shifted[15:0]};
        'b1_000 : readDataMasked_M = {{56{DM_readData_shifted[7]}},  DM_readData_shifted[7:0]};
        default : readDataMasked_M = readMask & DM_readData_shifted;
    endcase

endmodule