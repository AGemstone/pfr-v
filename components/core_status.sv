module core_status #(parameter N = 64)
                    (input logic[15:0] trapTrigger,
                     input logic trapReturn, mstatusCSREnable, clk, 
                     input logic reset,
			         input logic[N-1:0] csrIn,
			         output logic[1:0] currentMode,
			         output logic[N-1:0] mstatus);
	
	// logic[N-1:0] mstatus;
    // localparam mstatus_mask = {{46'b0}, {1'b1}, {4'b0}, {2'b11}, 
                            // {3'b0}, {1'b1}, {3'b0}, {1'b1}, 
                            // {3'b0}};
    logic[N-1:0] mstatus_mask; 
    
	logic[1:0] mode, modeTrapTrigger, modeTrapReturn;
    logic writeEnable;
	localparam int mie = 3;
	localparam int mpie = 7;
	localparam int mpp = 12;

    assign writeEnable = |{trapTrigger} | trapReturn;
    assign modeTrapTrigger = trapTrigger ? 2'b11 : modeTrapReturn;
    assign modeTrapReturn = trapReturn ? mstatus[mpp:mpp-1] : mode;
    
    flopre_init #(2, 2'b11) currentPrivilege(.clk(clk),
                                             .reset(reset),
                                             .enable(writeEnable),
                                             .d(modeTrapTrigger),
                                             .q(mode));

    // {MPP, MPIE, MIE}
    logic[3:0] mstatusTrapTrigger, mstatusTrapReturn, mstatusCSRInPriv;
    logic[N-1:0] mstatusCSRIn;

    assign mstatusTrapTrigger = trapTrigger ? 
                                {mode, mstatus[mie], 1'b0} : 
                                mstatusTrapReturn;
    
    assign mstatusTrapReturn = trapReturn ?
                               {{2'b0}, {1'b1}, mstatus[mpie]} : 
                               mstatusCSRInPriv;
    
    assign mstatusCSRInPriv = mstatusCSREnable ?
                           {csrIn[mpp:mpp-1], csrIn[mpie], csrIn[mie]} :
                           {mstatus[mpp:mpp-1], mstatus[mpie], mstatus[mie]};

    assign mstatusCSRIn = {mstatus[63:13], 
                           mstatusTrapTrigger[3:2], mstatus[10:8], 
                           mstatusTrapTrigger[1],   mstatus[6:4], 
                           mstatusTrapTrigger[0],   mstatus[2:0]};

    flopre_init #(N, 64'h200000000) mstatus_csr(.clk(clk), 
                                                .reset(reset),
                                                .enable(writeEnable | mstatusCSREnable),
                                                .d(mstatusCSRIn),
                                                .q(mstatus));
	 assign currentMode = mode;
     
		
endmodule