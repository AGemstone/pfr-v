module memWriteMask(input logic[2:0] select, memWidth,
                    output logic [7:0] byteenable);
    logic[7:0] writeMask;
    assign writeMask = {{4{memWidth[2]}},{2{memWidth[1]}}, memWidth[0], 1'b1};
    assign byteenable = writeMask << select;
endmodule