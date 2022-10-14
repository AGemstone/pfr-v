// Testbench SingleCycleProcessorPatterson
// Top-level Entity: processor_arm

`timescale 100ps/1ps

module processor_tb();
  localparam  N = 64;
  logic        	CLOCK_50, reset;
  logic CLOCK_200;
  logic        	DM_writeEnable,DM_readEnable;
  logic [N-1:0] 	DM_writeData, DM_addr, DM_readData;
  logic 			dump;
  // logic Zero_Flag;
  // logic [16:0] current_inst;

  
  // instantiate device under test
  processor_arm #(64) dut(.CLOCK_50(CLOCK_50),
                          .reset(reset),
                          .DM_readData(DM_readData),
                          .DM_writeData(DM_writeData),
                          .DM_addr(DM_addr),
                          .DM_writeEnable(DM_writeEnable),
                          .DM_readEnable(DM_readEnable),
                          .dump(dump));
    
  // generate clock
  always     // no sensitivity list, so it always executes
    begin
      #100 CLOCK_50 = ~CLOCK_50; 
    end
    always     // no sensitivity list, so it always executes
    begin
      #25 CLOCK_200 = ~CLOCK_200;
    end
    
  initial
    begin
      CLOCK_200 = 0;
      CLOCK_50 = 0; reset = 1; dump = 0;
      #200 reset = 0; 
      #62000 dump = 1; 
     #200 $stop;
  end 
endmodule
