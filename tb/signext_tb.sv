module signext_tb();
  logic [31:0] a;
  logic [63:0] y;
  
  // instantiate device under test
  signext dut(a, y);
  
  // apply inputs one at a time
  initial begin
  //positive int test
  a = 32'b111_1100_0010_0_1111_1111_11_00001_00001; #10; //ldur test
  a = 32'b111_1100_0000_0_1111_1111_11_00001_00001; #10; //stur test
  a = 32'b101_1010_0_000_0111_1111_1111_1111_00001; #10; //cbz test
  //negative int test
  a = 32'b111_1100_0010_1_0111111111_00001_00001; # 10; //ldur test
  a = 32'b111_1100_0000_1_0111111111_00001_00001; # 10; //stur test
  a = 32'b101_1010_0_100_1111111111111111_00001; # 10; //cbz test
  end
endmodule