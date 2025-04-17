module hazard (
    input logic ID_EX_MemRead, PCSrc, ID_EX_PCSrc,
	 input logic[2:0] IF_ID_Branch,
    input logic[4:0] ID_EX_RegisterRd, IF_ID_RegisterRs1, IF_ID_RegisterRs2, EX_MEM_RegisterRd, MEM_WB_RegisterRd,
    output logic PCEnable, ControlEnable, IF_ID_writeEnable, IF_ID_reset,
    output logic[1:0] cnt
);
    logic [1:0] counter = 0;
	 
	 logic branch_dep_EX, branch_dep_MEM, branch_dep_WB;
    assign branch_dep_EX = (IF_ID_Branch != 3'b000) && 
                           ((IF_ID_RegisterRs1 == ID_EX_RegisterRd) || 
                            (IF_ID_RegisterRs2 == ID_EX_RegisterRd));
    assign branch_dep_MEM = (IF_ID_Branch != 3'b000) && 
                            ((IF_ID_RegisterRs1 == EX_MEM_RegisterRd) || 
                             (IF_ID_RegisterRs2 == EX_MEM_RegisterRd));
    assign branch_dep_WB = (IF_ID_Branch != 3'b000) && 
                           ((IF_ID_RegisterRs1 == MEM_WB_RegisterRd) || 
                            (IF_ID_RegisterRs2 == MEM_WB_RegisterRd));
	 
    always_comb
        if (ID_EX_MemRead &
            ((ID_EX_RegisterRd == IF_ID_RegisterRs1) |
            (ID_EX_RegisterRd == IF_ID_RegisterRs2))) begin
                PCEnable = 1'b0;
                ControlEnable = 1'b0;
                IF_ID_writeEnable = 1'b0;
        end
		  else if (IF_ID_Branch != 3'b0 & PCSrc == 1'b1) begin
		          PCEnable = 1'b0;
                ControlEnable = 1'b0;
                IF_ID_writeEnable = 1'b0;
		  end
		  else if (branch_dep_EX || branch_dep_MEM || branch_dep_WB) begin
		          PCEnable = 1'b0;
                ControlEnable = 1'b0;
                IF_ID_writeEnable = 1'b0;		  
		  end

        else begin
                PCEnable = 1'b1;
                ControlEnable = 1'b1;
                IF_ID_writeEnable = 1'b1;
        end
		  
        
    assign cnt = counter;
	 assign IF_ID_reset = ID_EX_PCSrc;

endmodule