module except_E #(parameter N = 64) 
                 (input logic[N-1:0] DM_addr,
                  input logic[1:0] memOp,
                  output logic[6:0] exceptSignal);
    
    logic alignDetect;
    assign alignDetect = (|{DM_addr[3:0]});
    // memOp = 0 is read, memOp = 1 is write
    // Format: breakpoint, write page fault,read page fault, write access fault/misalign, read access fault/misalign
    assign exceptSignal = memOp ?
                          {{1'b0}, {2'b0}, {1'b0}, {alignDetect & memOp[1]}, {1'b0}, {alignDetect & memOp[0]}} :
                          0;

endmodule