module flopr_tb();
  logic clk,reset;
  logic [63:0] d;
  logic [63:0] q;
  
  // instantiate device under test
  flopr dut(clk,reset,d, q);
  
//clk setup
// always begin 
//   clk = 1;#5;
//   clk = 0;#5;
// end

  // apply inputs one at a time
  initial begin
  for (int i = 0; i < 10; i=i+1) 
        begin
            clk = 0; #5;
            d = i;
            clk = 1; #5;
  end
  d='1; reset=0; #10; //shouldnt change q
  d='1; clk=1; #10; //q should be 11...11 
  d='0; clk=0; #10; //shouldnt change q
  d=63'd127; clk=1; #10; //change q to 00...1111_1111
  d='1; clk=0; reset=1; #10; // should change q to 00...00

  
  $stop;
  end
endmodule