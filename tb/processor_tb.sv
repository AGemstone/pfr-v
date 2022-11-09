`timescale 1ps/1ps

module processor_tb();
  localparam  N = 64;
  logic CLOCK_50, reset;
  logic CLOCK_200;
  logic DM_writeEnable,DM_readEnable;
  logic[N-1:0] DM_writeData, DM_addr, DM_readData;
  logic dump;
  
  // instantiate device under test
    core #(64) dut(.clk(CLOCK_50),
                   .reset(reset),
                   .DM_readData(DM_readData),
                   .DM_writeData(DM_writeData),
                   .DM_addr(DM_addr),
                   .DM_writeEnable(DM_writeEnable),
                   .DM_readEnable(DM_readEnable),
                   .dump(dump));
  
  
  // generate clock
  // no sensitivity list, so it always executes
  always     
      begin
        #10 CLOCK_50 = ~CLOCK_50;
    end
    // always
    // begin
    //   #25 CLOCK_200 = ~CLOCK_200;
    // end
    
    initial
    begin
        CLOCK_200 = 0;
        CLOCK_50 = 0; reset = 1; dump = 0;
        #20 reset = 0; 
        #6200 dump = 1; 
        #20 $stop;
    end 
endmodule
