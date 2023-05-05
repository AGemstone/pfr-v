`timescale 1ps/1ps

module processor_tb();
  localparam  N = 64;
  int fd, i;
  logic CLOCK_50, reset;
  logic [N-1:0] DM_readData;
  logic [N-1:0] DM_writeData, DM_addr;
  logic DM_writeEnable, DM_readEnable;
  logic [14:0] coprocessorIOAddr;
  logic [4:0] coprocessorIOControl;
  logic [N-1:0] coprocessorIODataOut;
  logic [N-1:0] coprocessorIODataIn;
  logic [1:0] coprocessorIODebugFlags;
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
       .coprocessorIODataIn(coprocessorIODataIn),
       .coprocessorIODebugFlags(coprocessorIODebugFlags)
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
      fd = $fopen("./mem.dump", "w");
      for (int j = 0 ; j < 1; j++) begin
        coprocessorIODataOut = 0; 
        coprocessorIOAddr = 'h0000; 
        coprocessorIOControl = 'b00000;
        CLOCK_50 = 0; 
        reset = 1;
        // #20
        // coprocessorIOControl = 'b10000;
        // coprocessorIOAddr = 1;
        // coprocessorIODataOut = 'h100;
        #20 
        reset = 0;
        // #320 
        // //coprocessorIOControl = 1;
        // $display ("Internal signal value is %h", processor_tb.dut.dp.DECODE.registers.ram[1]);
        // #20 
        // coprocessorIOControl = 0;
        // $display ("Internal signal value is %h", processor_tb.dut.dp.DECODE.registers.ram[1]);
        #6000
        $display ("Dumping at %d\n", $time);
        // Memdump
        for(i = 0; i < 4096; i++) begin
          coprocessorIOAddr = i * 8; 
          coprocessorIOControl = 'b00_10_0;
          #40
          $fwrite (fd, "%4d: 0x%x\n", i, coprocessorIODataIn);
        end
        #20
        $fwrite (fd, "After Clear\n");
        $display ("Clearing at %d\n", $time);
        // Memclear
        for(i = 0; i < 4096; i++) begin
          coprocessorIOAddr = i * 8; 
          coprocessorIODataOut = 0; 
          coprocessorIOControl = 'b00_01_0;
          #40
          coprocessorIOControl = 'b00_01_0;

        end
        #20
        // Memdump
        for(i = 0; i < 4096; i++) begin
          coprocessorIOAddr = i * 8; 
          coprocessorIOControl = 'b00_10_0;
          #40
          $fwrite (fd, "%4d: 0x%x\n", i, coprocessorIODataIn);
        end


      end
      
      $fclose(fd);
      $stop;
    end 
endmodule
