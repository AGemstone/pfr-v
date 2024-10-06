`timescale 1ps/1ps
module DE0_NANO_tb();

  // Define signals for DUT ports
  logic [1:0] KEY;
  logic CLOCK_50;
  logic [7:0] LED;
  
  // Instantiate device under test
  DE0_NANO  dut(
    .KEY(KEY),        // Connect KEY port of DUT
    .CLOCK_50(CLOCK_50),  // Connect CLOCK_50 port of DUT
    .LED(LED)         // Connect LED port of DUT
  );
    
  // Generate clock
  always
    begin
      #10 CLOCK_50 = ~CLOCK_50; 
    end
  
  // Initialize signals
  initial
    begin
      CLOCK_50 = 0;
      KEY = 0;
      #20 KEY = 1;	
    #1000 $stop; // Stop simulation after some time
    end 
endmodule