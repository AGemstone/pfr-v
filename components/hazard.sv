module hazard (
    input logic ID_EX_MemRead, PCSrc,
	 input logic[2:0] IF_ID_Branch,
    input logic[4:0] ID_EX_RegisterRd, IF_ID_RegisterRs1, IF_ID_RegisterRs2, EX_MEM_RegisterRd,
    output logic PCEnable, ControlEnable, IF_ID_writeEnable, IF_ID_reset,
    output logic[1:0] cnt
);
    logic [1:0] counter = 0;
    always_comb
        if (ID_EX_MemRead &
            ((ID_EX_RegisterRd == IF_ID_RegisterRs1) |
            (ID_EX_RegisterRd == IF_ID_RegisterRs2))) begin
                PCEnable = 1'b0;
                ControlEnable = 1'b0;
                IF_ID_writeEnable = 1'b0;
        end
		  else if (IF_ID_Branch != 3'b0 &
		           ((ID_EX_RegisterRd == IF_ID_RegisterRs1) |
                 (ID_EX_RegisterRd == IF_ID_RegisterRs2))) begin
				         PCEnable = 1'b0;
                     ControlEnable = 1'b0;
                     IF_ID_writeEnable = 1'b0;
		  end
		  else if (IF_ID_Branch != 3'b0 &
		           ((EX_MEM_RegisterRd == IF_ID_RegisterRs1) |
                 (EX_MEM_RegisterRd == IF_ID_RegisterRs2))) begin
				         PCEnable = 1'b0;
                     ControlEnable = 1'b0;
                     IF_ID_writeEnable = 1'b0;
		  end
        else begin
                PCEnable = 1'b1;
                ControlEnable = 1'b1;
                IF_ID_writeEnable = 1'b1;
        end
		  
		  // Agregar caso del branch agregar else if
        
    assign cnt = counter;
	 assign IF_ID_reset = PCSrc;

endmodule