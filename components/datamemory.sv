module dmem #(parameter N=64,M=32) 
            (input logic clk,reset,
            input logic[N-1:0] DM_writeData,
            input logic[11:0] wordAddr,
            input logic readEnable,
            input logic writeEnable,
            input logic[2:0] memWidth,
            input logic[2:0] byteOffset,
            input logic [M-1:0] IM_readData,
            input logic dataSelect,
            output logic[N-1:0] readData);

    logic [N-1:0] DM_readData, readROMData;
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
    // flopr #(N) romreadflop (
    //     .clk(clk),
    //     .reset(reset),
    //     .d({{(N-M){1'b0}}, IM_readData}),
    //     .q(readROMData));
    assign readROMData = {{(N-M){1'b0}}, IM_readData};
    assign readData = dataSelect ? readROMData : DM_readData;

endmodule