module regfile_tb();
    logic [4:0] ra1;
	logic [4:0] ra2;
	logic [4:0] wa3;
	logic we3, clk;
	logic [63:0] wd3;

	logic [63:0] rd1;
	logic [63:0] rd2;

    logic [63:0] rd_db, wd_db;
    logic [4:0] wa_db, ra_db;
    logic we_db;

    regfile dut(ra1, ra2, ra_db, wa3, wa_db, wd3, wd_db, we3, clk, we_db, rd1, rd2, rd_db);

    initial begin
        for (int i = 0; i < 32; i = i + 1) 
        begin
            clk = 0; #5;
            ra1 = i;
            ra2 = i;
            clk = 1; #5;
        end
        //check if we can alter content
        clk = 0; #5
        clk = 1; we3 = 1; wa3 = 5'b00001;wd3 = '1; ra1 = 5'b00001; #5;
        //check if we cant alter content
        clk = 0; #5;
        assert(rd1 == '1);
        clk = 1; we3 = 0; wa3 = 5'b00001; wd3 = '0; ra1 = 5'b00001; #5;
        clk = 0; #5
        assert(rd1 == '1);
        clk = 1; we3 = 1; wa3 = 5'b11111; wd3 = '1; ra1 = 5'b11111; #5;
        clk = 0; #5
        assert(rd1 == '0);
    $stop;
    end
endmodule