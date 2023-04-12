`timescale 1ps/1ps

module processor_tb();
  localparam  N = 64;
  
  
  logic CLOCK_50, reset;
  logic [N-1:0] DM_readData;
  logic [N-1:0] DM_writeData, DM_addr;
  logic DM_writeEnable, DM_readEnable;
  logic [14:0] coprocessorIOAddr;
  logic [3:0] coprocessorIOControl;
  logic [N-1:0] coprocessorIODataOut;
  logic [N-1:0] coprocessorIODataIn;
  // instantiate device under test
    core #(N) dut(
       .clk(CLOCK_50), 
       .reset(reset),
       .DM_readData(DM_readData),
       .DM_writeData(DM_writeData), 
       .DM_addr(DM_addr),
       .DM_writeEnable(DM_writeEnable), 
       .DM_readEnable(DM_readEnable),
       .coprocessorIOAddr(coprocessorIOAddr),
       .coprocessorIOControl(coprocessorIOControl),
       .coprocessorIODataOut(coprocessorIODataOut),
       .coprocessorIODataIn(coprocessorIODataIn)
       );
  

  // generate clock
  // no sensitivity list, so it always executes
  always     
      begin
        #10 CLOCK_50 = ~CLOCK_50;
    end

    initial
    begin
        coprocessorIODataOut = 1; coprocessorIOAddr = 4; coprocessorIOControl = 0;
        CLOCK_50 = 0; reset = 1;
        #20 reset = 0;
        #500 coprocessorIOControl = 1;
        $display ("Internal signal value is %h", processor_tb.dut.dp.DECODE.registers.ram[4]);
        #20 coprocessorIOControl = 0;
        $display ("Internal signal value is %h", processor_tb.dut.dp.DECODE.registers.ram[4]);
        #10000
        $display ("Internal signal value is %h", processor_tb.dut.dp.DECODE.registers.ram[10]);
        $stop;
    end 
endmodule
