`timescale 1ps/1ps

module processor_tb();
  localparam  N = 64;
  int fd, i;
  logic SIG_CLOCK_50, SIG_reset;
  logic [N-1:0] DM_readData;
  logic [N-1:0] DM_writeData, DM_addr;
  logic DM_writeEnable, DM_readEnable;
  logic [14:0] coprocessorIOAddr;
  logic [4:0] coprocessorIOControl;
  logic [N-1:0] coprocessorIODataOut;
  logic [N-1:0] coprocessorIODataIn;
  logic [1:0] coprocessorIODebugFlags;
  typedef enum logic[6:0] {LOAD   = 'b0000011,
                           STORE  = 'b0100011,
                           RFMT   = 'b0110011,
                           RFMT_W = 'b0111011,
                           IFMT   = 'b0010011,
                           IFMT_W = 'b0011011,
                           SYSTEM = 'b1110011,
                           BRANCH = 'b1100011,
                           LUI    = 'b0110111,
                           AUIPC  = 'b0010111,
                           JAL    = 'b1101111,
                           JALR   = 'b1100111
                           } Opcode;
  Opcode opcode;
  // instantiate device under test
    core #(N) dut(
       .clk(SIG_CLOCK_50), 
       .reset(SIG_reset),
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
  
  assign opcode = Opcode'(processor_tb.dut.instrMem.q0[6:0]);
  // generate clock
  // no sensitivity list, so it always executes
    always     
      begin
        #10 
        SIG_CLOCK_50 = ~SIG_CLOCK_50;
    end
    initial
    begin
      fd = $fopen("./mem.dump", "w");
      for (int j = 0 ; j < 1; j++) begin
        coprocessorIODataOut = 1; 
        coprocessorIOAddr = 'h1000; 
        coprocessorIOControl = 'b11000;
        SIG_CLOCK_50 = 0; 
        SIG_reset = 1;
        #20
        coprocessorIOControl = 'b10000;
        coprocessorIOAddr = 1;
        coprocessorIODataOut = 'h100;
        #20 
        SIG_reset = 0;
        #40 
        coprocessorIOControl = 1;
        $display ("Internal signal value is %h", processor_tb.dut.dp.DECODE.registers.ram[1]);
        #20 
        coprocessorIOControl = 0;
        $display ("Internal signal value is %h", processor_tb.dut.dp.DECODE.registers.ram[1]);
        #500000
        $display ("Dumping at %d\n", $time);
        // Memdump
        for(i = 0; i < 4096; i++) begin
          coprocessorIOAddr = i * 8; 
          coprocessorIOControl = 'b00_10_0;
          #40
          $fwrite (fd, "%4d: 0x%x\n", i, coprocessorIODataIn);
        end
        // #20
        // $fwrite (fd, "After Clear\n");
        // $display ("Clearing at %d\n", $time);
        // // Memclear
        // for(i = 0; i < 4096; i++) begin
        //   coprocessorIOAddr = i * 8; 
        //   coprocessorIODataOut = 0; 
        //   coprocessorIOControl = 'b00_01_0;
        //   #40
        //   coprocessorIOControl = 'b00_01_0;

        // end
        // #20
        // Memdump
        // for(i = 0; i < 4096; i++) begin
        //   coprocessorIOAddr = i * 8; 
        //   coprocessorIOControl = 'b00_10_0;
        //   #40
        //   $fwrite (fd, "%4d: 0x%x\n", i, coprocessorIODataIn);
        // end


      end
      
      $fclose(fd);
      $stop;
    end 
endmodule
