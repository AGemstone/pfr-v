module except_F #(parameter N = 64) 
                 (input logic[N-1:0] PC,
                  input logic iAlign,
                  output logic[3:0] exceptSignal);

    // NOTE: if we decide to use iAlign (ie support C extension) in the future 
    // PC[1:0] check should be changed
    // Format: breakpoint, page fault, access fault, misalign
    assign exceptSignal = 4'b0; 
    // {{3'b0}, {(|{PC[1:0]})}};

endmodule