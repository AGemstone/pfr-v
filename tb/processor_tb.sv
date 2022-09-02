// Testbench SingleCycleProcessorPatterson
// Top-level Entity: processor_arm

module processor_tb();
	localparam  N = 64;
	logic        	CLOCK_50, reset;
	logic        	DM_writeEnable;
	logic [N-1:0] 	DM_writeData, DM_addr;
	logic 			dump;
  logic Zero_Flag;
  logic [16:0] current_inst;
  logic [31:0] opcode;
  logic [5:0] control;
  
  // instantiate device under test
  processor_arm  dut (.CLOCK_50(CLOCK_50), 
                      .reset(reset),
                      .DM_writeData(DM_writeData), 
                      .DM_addr(DM_addr),
                      .DM_writeEnable(DM_writeEnable),
                      .dump(dump),
                      .Zero_Flag(Zero_Flag),
                      .current_inst(current_inst),
                      .opcode(opcode),
                      .control(control));
    
  // generate clock
  always     // no sensitivity list, so it always executes
    begin
      #5 CLOCK_50 = ~CLOCK_50; 
    end
    
  initial
    begin
      CLOCK_50 = 0; reset = 1; dump = 0;
      #20 reset = 0; 
      #620 dump = 1; 
	   #20 $stop;
	end 
endmodule
