`timescale 1ps/1ps

module processor_tb();
  localparam  N = 64;
  
  logic CLOCK_50, reset;
  logic [N-1:0] DM_readData;
  logic [N-1:0] DM_writeData, DM_addr;
  logic DM_writeEnable, DM_readEnable;
  logic [14:0] coprocessorIOAddr;
  logic [4:0] coprocessorIOControl;
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
        #10 
        CLOCK_50 = ~CLOCK_50;
    end

    initial
    begin
        // coprocessorIODataOut = 168; 
        // coprocessorIOAddr = 'h1000; 
        // coprocessorIOControl = 'b11000;
        coprocessorIOControl = 'b00000;
        CLOCK_50 = 0; 
        reset = 1;
        // #20
        // coprocessorIOControl = 'b10000;
        // coprocessorIOAddr = 10;
        // coprocessorIODataOut = 'h40000000;
        #20 
        reset = 0;
        // #3380 
        // coprocessorIOControl = 1;
        // $display ("Internal signal value is %h", processor_tb.dut.dp.DECODE.registers.ram[4]);
        // #20 
        // coprocessorIOControl = 0;
        // $display ("Internal signal value is %h", processor_tb.dut.dp.DECODE.registers.ram[4]);
        #1000
        for(int i = 0; i < 4;i++)begin
        coprocessorIOAddr = i * 8; 
        coprocessorIOControl = 'b01000;
        #20
        $display ("%x\n",coprocessorIODataIn);
        end
        $stop;
    end 
endmodule
