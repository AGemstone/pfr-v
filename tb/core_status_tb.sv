module core_status_tb();

    localparam N = 64;
    logic[15:0] trapTrigger;
    logic trapReturn, mstatusCSREnable, clk;
    logic reset;
    logic[N-1:0] csrIn;
    logic[1:0] currentMode;
    logic[N-1:0] mstatus;
    core_status #(N) dut (.trapTrigger(trapTrigger),
                          .trapReturn(trapReturn),
                          .mstatusCSREnable(mstatusCSREnable), 
                          .clk(clk), 
                          .reset(reset),
			              .csrIn(csrIn),
			              .currentMode(currentMode),
			              .mstatus(mstatus));
    always
    begin
        #5 clk = ~clk;
    end
    initial 
    begin
        reset = 1; 
        clk = 0;
        csrIn = 'b1001;
        mstatusCSREnable = 0; 
        trapTrigger = 0;
        trapReturn = 0;
        #20 
        reset = 0;
        #10 
        trapTrigger = 1;
        #50
        trapTrigger = 0;
        trapReturn = 1;
        #50
        $stop;
    end
endmodule