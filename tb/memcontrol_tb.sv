module memcontrol_tb ();
localparam N = 64;
logic clk, reset;
logic[1:0] op;
logic[17:0] dataAddr;
logic[N-1:0] dataWrite;
logic[N-1:0] dataRead;
logic[12:0] dramAddr;
logic[15:0] dramDataWrite;
logic[15:0] dramDataRead;
logic[1:0] bankSel;
logic readReady;
logic[1:0] dataMask;
logic CS_N, WE_N, CAS_N, RAS_N;


  // instantiate device under test
  memControl  dut (.clk(clk), 
                   .reset(reset),
                   .op(op),
                   .dataAddr(dataAddr),
                   .dataWrite(dataWrite),
                   .dataRead(dataRead),
                   .dramAddr(dramAddr),
                   .dramDataWrite(dramDataWrite),
                   .dramDataRead(dramDataRead),
                   .bankSel(bankSel),
                   .readReady(readReady),
                   .dataMask(dataMask),
                   .CS_N(CS_N), 
                   .WE_N(WE_N), 
                   .CAS_N(CAS_N), 
                   .RAS_N(RAS_N));
    
  // generate clock
  always     // no sensitivity list, so it always executes
    begin
      #4 clk = ~clk; 
    end
    
  initial
    begin
        clk = 0; reset = 1;
        dataRead = 0; dataWrite = 0; dataAddr = 0; op = 0;
        #16 reset = 0;
        #3000 $stop;
    end 
endmodule
