module except_E #(parameter N = 64) 
                 (input logic[N-1:0] DM_addr,
                  input logic[1:0] memOp,
                  input [2:0] memWidth,
                  output logic[6:0] exceptSignal);
    
    logic [7:0] byteMask;
    logic [8:0] shiftedMask;
    logic alignDetect;
    assign byteMask = {{4{memWidth[2]}},{2{memWidth[1]}}, memWidth[0], 1'b1};
    assign shiftedMask = byteMask << DM_addr[2:0];
    assign alignDetect = shiftedMask[8];
    // assign alignDetect = 1'b0;
    // memOp = 0 is read, memOp = 1 is write
    // Format: breakpoint, write page fault,read page fault, write access fault/misalign, read access fault/misalign
    
    assign exceptSignal = {{1'b0}, {2'b0}, {1'b0}, {alignDetect & memOp[1]}, {1'b0}, {alignDetect & memOp[0]}};

endmodule