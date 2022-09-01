// Testbench DE0_NANO_PipelinedProcessorPatterson
// Top-level Entity: DE0_NANO_arm

module DE0_NANO_tb();
	logic [1:0] KEY;
	logic CLOCK_50;
	logic [7:0] LED;
	logic [63:0] write_data_out;
	logic dm_write_enable_out;
  
  // instantiate device under test
  DE0_NANO  dut (KEY,CLOCK_50,LED, write_data_out,dm_write_enable_out);
    
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
		#2400 $stop;
	end 
endmodule 