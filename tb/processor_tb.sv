`timescale 1ps/1ps

module processor_tb();
  localparam  N = 64;
  
  
  logic CLOCK_50, reset;
  logic [N-1:0] DM_readData;
  logic [N-1:0] DM_writeData, DM_addr;
  logic DM_writeEnable, DM_readEnable;
  logic dump;
  logic [14:0] coprocessorIOAddr;
  logic [2:0] coprocessorIOControl;
  logic [N-1:0] coprocessorIODataOut;
  logic [N-1:0] coprocessorIODataIn;
  // instantiate device under test
    core #(N) dut(
       CLOCK_50, reset,
       DM_readData,
       DM_writeData, DM_addr,
       DM_writeEnable, DM_readEnable,
       dump,
       coprocessorIOAddr,
       coprocessorIOControl,
       coprocessorIODataOut,
       coprocessorIODataIn);
  

  // generate clock
  // no sensitivity list, so it always executes
  always     
      begin
        #10 CLOCK_50 = ~CLOCK_50;
    end

    initial
    begin
        coprocessorIODataIn = 0;
        coprocessorIOControl = 0;
        CLOCK_50 = 0; reset = 1; dump = 0;
        #20 reset = 0; 
        #10000 dump = 1; 
        #20 $stop;
    end 
endmodule
