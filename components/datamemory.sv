module dmem #(parameter N=64) 
            (input logic clk,
            input logic[N-1:0] DM_writeData,
            input logic[7:0] wordAddr,
            input logic readEnable,
            input logic writeEnable,
            input logic[2:0] memWidth,
            input logic[2:0] byteOffset,
            output logic[N-1:0] DM_readData);

    logic [7:0] DM_writeMask;
    memWriteMask MEMWRITE_MASK(.select(byteOffset),
                               .memWidth(memWidth),
                               .byteenable(DM_writeMask));
    
    dmemip m9kmem(.clock(clk),
                  .data(DM_writeData),
                  .address(wordAddr),
                  .rden(readEnable),
                  .byteena(DM_writeMask),
                  .wren(writeEnable),
                  .q(DM_readData));

endmodule