// Testbench DE0_NANO_PipelinedProcessorPatterson
// Top-level Entity: DE0_NANO_arm

`timescale 1ps/1ps
module DE0_NANO_tb();
	logic [1:0] KEY;
	logic CLOCK_50;
	logic [7:0] LED;
  
  // instantiate device under test
  DE0_NANO  dut(KEY,CLOCK_50,LED);
    
  // generate clock
  always     // no sensitivity list, so it always executes
    begin
      #10 CLOCK_50 = ~CLOCK_50; 
    end
  initial
    begin
      CLOCK_50 = 0; KEY = 0;
      #20 KEY = 1;	
      //#80;
		#1000 $stop;
	end 
endmodule 