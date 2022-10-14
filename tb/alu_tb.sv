module alu_tb();
    logic [63:0] a, b, result;
    logic [3:0] ALUControl;
    logic zero;

    alu dut(.a(a),.b(b),.ALUControl(ALUControl),.result(result),.zero(zero));

    initial begin
    //two negatives
    // a = -1; b = -2;
    // ALUControl = 4'b0000;#10; assert(result == -2); assert(zero == 0);
    // ALUControl = 4'b0001;#10; assert(result == -1); assert(zero == 0);
    // ALUControl = 4'b0010;#10; assert(result == -3); assert(zero == 0);
    // ALUControl = 4'b0110;#10; assert(result == 1); assert(zero == 0);
    // ALUControl = 4'b0111;#10; assert(result == -2); assert(zero == 0);
    // ALUControl = 4'b1100;#10; assert(result == 0); assert(zero == 1);
    // //one negative one positive
    // a = 1; b = -2; 
    // ALUControl = 4'b0000;#10; assert(result == 0); assert(zero == 1);
    // ALUControl = 4'b0001;#10; assert(result == -1); assert(zero == 0);
    // ALUControl = 4'b0010;#10; assert(result == -1); assert(zero == 0);
    // ALUControl = 4'b0110;#10; assert(result == 3); assert(zero == 0);
    // ALUControl = 4'b0111;#10; assert(result == -2); assert(zero == 0);
    // ALUControl = 4'b1100;#10; assert(result == 0); assert(zero == 1);
    // //two positives
    // a = 1; b = 1;
    // ALUControl = 4'b0000;#10; assert(result == 1); assert(zero == 0);
    // ALUControl = 4'b0001;#10; assert(result == 1); assert(zero == 0);
    // ALUControl = 4'b0010;#10; assert(result == 2); assert(zero == 0);
    // ALUControl = 4'b0110;#10; assert(result == 0); assert(zero == 1);
    // ALUControl = 4'b0111;#10; assert(result == 1); assert(zero == 0);
    // ALUControl = 4'b1100;#10; assert(result == -2); assert(zero == 0);

    a = -1; b = -2;
    //lt
    ALUControl = 4'b0100; #10;
    //ge
    ALUControl = 4'b0101; #10;
    //signed lt
    ALUControl = 4'b1100; #10;
    //signed ge
    ALUControl = 4'b1101; #10;
    // //left shift
    // ALUControl = 4'b0011; #10;
    // //right shift
    // ALUControl = 4'b0111; #10;
    // //arith shift
    // ALUControl = 4'b1011; #10;
    ALUControl = 4'b1111; #10;
    a = -1; b = 2;
     //lt
    ALUControl = 4'b0100; #10;
    //ge
    ALUControl = 4'b0101; #10;
    //signed lt
    ALUControl = 4'b1100; #10;
    //signed ge
    ALUControl = 4'b1101; #10;
    //left shift
    ALUControl = 4'b0011; #10;
    //right shift
    ALUControl = 4'b0111; #10;
    //arith shift
    ALUControl = 4'b1011; #10;
    
    ALUControl = 4'b1111; #10;
    a = 1; b = 2;
     //lt
    ALUControl = 4'b0100; #10;
    //ge
    ALUControl = 4'b0101; #10;
    //signed lt
    ALUControl = 4'b1100; #10;
    //signed ge
    ALUControl = 4'b1101; #10;
    //left shift
    ALUControl = 4'b0011; #10;
    //right shift
    ALUControl = 4'b0111; #10;
    //arith shift
    ALUControl = 4'b1011; #10;
    end

endmodule