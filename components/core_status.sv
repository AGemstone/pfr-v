module core_status #(parameter N = 64)
                    (input logic[15:0] trapTrigger,
                     input logic trapReturn, mstatusCSREnable, clk, 
                     input logic reset,
			         input logic[N-1:0] csrIn,
			         output logic[1:0] currentMode,
			         output logic[N-1:0] mstatus);
	
	// logic[N-1:0] mstatus;
    localparam logic[N-1:0] mstatus_mask = {{46'b0}, {1'b1}, {4'b0}, {2'b11}, 
                                            {3'b0}, {1'b1}, {3'b0}, {1'b1}, 
                                            {3'b0}};
	logic[1:0] mode, modeTrapTrigger, modeTrapReturn;
    logic writeEnable;
	localparam int mie = 3;
	localparam int mpie = 7;
	localparam int mpp = 12;
    localparam int mprv = 17;

    assign writeEnable = (|{trapTrigger}) | trapReturn;
    assign modeTrapTrigger = trapTrigger ? 2'b11 : modeTrapReturn;
    assign modeTrapReturn = trapReturn ? mstatus[mpp:mpp-1] : mode;
    
    flopre_init #(2, 2'b11) currentPrivilege(.clk(clk),
                                             .reset(reset),
                                             .enable(writeEnable),
                                             .d(modeTrapTrigger),
                                             .q(mode));

    logic[N-1:0] mstatusTrapTrigger, mstatusTrapReturn, mstatusCSRIn;
        always_comb begin
        if (|{trapTrigger}) 
        begin 
            mstatusTrapTrigger[N-1:mpp+1] = mstatus[N-1:mpp+1];
            mstatusTrapTrigger[mpp-2:mpie+1] = mstatus[mpp-2:mpie+1];
            mstatusTrapTrigger[mpie-1:mie+1] = mstatus[mpie-1:mie+1];
            mstatusTrapTrigger[mie-1:0] = mstatus[mie-1:0];
            mstatusTrapTrigger[mpp:mpp-1] = mode;
            mstatusTrapTrigger[mpie] = mstatus[mie];
            mstatusTrapTrigger[mie] = 1'b0;
        end
        else 
            mstatusTrapTrigger = mstatusCSRIn;

        if (trapReturn) 
        begin
            mstatusTrapReturn[N-1:mpp+1] = mstatus[N-1:mpp+1];
            mstatusTrapReturn[mpp-2:mpie+1] = mstatus[mpp-2:mpie+1];
            mstatusTrapReturn[mpie-1:mie+1] = mstatus[mpie-1:mie+1];
            mstatusTrapReturn[mie-1:0] = mstatus[mie-1:0];
            mstatusTrapReturn[mpp:mpp-1] = 2'b0;
            mstatusTrapReturn[mie] = mstatus[mpie];
            mstatusTrapReturn[mpie] = 1'b1;
        end
        else 
            mstatusTrapReturn <= mstatusCSRIn;
        end
        assign mstatusCSRIn = mstatusCSREnable ? 
                              (mstatus & ~mstatus_mask) | (csrIn & mstatus_mask) :
                             mstatus;

    flopre_init #(N, 64'h200000000) mstatus_csr(.clk(clk), 
                                                .reset(reset),
                                                .enable(1'b1),
                                                .d(mstatusTrapTrigger),
                                                .q(mstatus));
	 assign currentMode = mode;
     
		
endmodule