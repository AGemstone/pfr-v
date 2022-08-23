module imem_tb();
    logic [5:0] addr;
    logic [31:0] q;

    imem dut(addr, q);

initial begin
    addr = 6'd00; #10; assert(q == 'hf8000000);
    addr = 6'd01; #10; assert(q == 'hf8008001);
    addr = 6'd02; #10; assert(q == 'hf8010002);
    addr = 6'd03; #10; assert(q == 'hf8018003);
    addr = 6'd04; #10; assert(q == 'hf8020004);
    addr = 6'd05; #10; assert(q == 'hf8028005);
    addr = 6'd06; #10; assert(q == 'hf8030006);
    addr = 6'd07; #10; assert(q == 'hf8400007);
    addr = 6'd08; #10; assert(q == 'hf8408008);
    addr = 6'd09; #10; assert(q == 'hf8410009);
    addr = 6'd10; #10; assert(q == 'hf841800a);
    addr = 6'd11; #10; assert(q == 'hf842000b);
    addr = 6'd12; #10; assert(q == 'hf842800c);
    addr = 6'd13; #10; assert(q == 'hf843000d);
    addr = 6'd14; #10; assert(q == 'hcb0e01ce);
    addr = 6'd15; #10; assert(q == 'hb400004e);
    addr = 6'd16; #10; assert(q == 'hcb01000f);
    addr = 6'd17; #10; assert(q == 'h8b01000f);
    addr = 6'd18; #10; assert(q == 'hf803800f);
    addr = 6'd19; #10; assert(q == 'h00000000);
end

endmodule;