module memWriteMask#(parameter N=64)(input logic[2:0] select, memWidth, 
                                     input logic[N-1:0] DM_writeData,
                                     output logic [7:0] byteenable,
                                     output logic[N-1:0] DM_writeData_M);
    logic[7:0] writeMask;
    assign writeMask = {{4{memWidth[2]}},{2{memWidth[1]}}, memWidth[0], 1'b1};
    assign byteenable = writeMask << select;
    assign DM_writeData_M = DM_writeData << {select, 3'b0};
endmodule