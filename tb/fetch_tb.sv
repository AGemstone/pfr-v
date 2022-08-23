module fetch_tb();
    logic [63:0] PCBranch_F;
    logic PC_Src_F, clk, reset;
    logic [63:0] imem_addr_F;

    always 
    begin
    clk = 0; #5;
    clk = 1; #5;
    end

    fetch dut(PCBranch_F, PC_Src_F, clk, reset, imem_addr_F);
    initial begin
        PCBranch_F = 64'd0; PC_Src_F = 1; reset = 0; #10;
        assert(imem_addr_F == 64'd0);
        PCBranch_F = 64'd64; PC_Src_F = 1; reset = 0; #10;
        assert(imem_addr_F == 64'd64);
        PC_Src_F =0; #20;
        assert(imem_addr_F == 64'd72);
        reset = 1; #10;
        assert(imem_addr_F == 64'd0);
        $stop;
    end
endmodule