module mux2_tb();
  logic [63:0] d0, d1,
  logic s;
  logic [63:0] y;
  
  // instantiate device under test
  mux2 dut(d0, d1, s, y);
  
  // apply inputs one at a time
  initial begin
  d0 = '0; d1='1; s=0;#10 ;
  d0 = '0; d1='1; s=1;#10 ;
  end
endmodule