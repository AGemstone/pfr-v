module forwarding (
    input logic EX_MEM_RegWrite, MEM_WB_RegWrite,
    input logic MEM_WB_MemRead,  // Add this to identify load instructions
    input logic [4:0] EX_MEM_RegisterRd, MEM_WB_RegisterRd,
    input logic [4:0] ID_EX_RegisterRs1, ID_EX_RegisterRs2,

    output logic [1:0] fwA,
    output logic [1:0] fwB
);

    assign load_use_case_A = (MEM_WB_MemRead && 
	                           EX_MEM_RegisterRd == ID_EX_RegisterRs1 && 
										EX_MEM_RegisterRd == MEM_WB_RegisterRd);

	 assign load_use_case_B = (MEM_WB_MemRead && 
	                           EX_MEM_RegisterRd == ID_EX_RegisterRs2 && 
										EX_MEM_RegisterRd == MEM_WB_RegisterRd);
    
    always_comb
        begin
        // EX hazard
        if (EX_MEM_RegWrite &&
        (EX_MEM_RegisterRd != 0) &&
        (EX_MEM_RegisterRd == ID_EX_RegisterRs1) &&
		  ~load_use_case_A) 
            fwA = 'b10;
        // MEM hazard
        else if (MEM_WB_RegWrite &&
        (MEM_WB_RegisterRd != 0) &&
        (MEM_WB_RegisterRd == ID_EX_RegisterRs1))
            fwA = 'b01;
        else
            fwA = 0;
        
        // EX hazard
        if (EX_MEM_RegWrite &&
        (EX_MEM_RegisterRd != 0) &&
        (EX_MEM_RegisterRd == ID_EX_RegisterRs2) &&
		  ~load_use_case_B) 
            fwB = 'b10;
        // MEM hazard
        else if (MEM_WB_RegWrite &&
        (MEM_WB_RegisterRd != 0) &&
        (MEM_WB_RegisterRd == ID_EX_RegisterRs2))
            fwB = 'b01;
        else
            fwB = 0;
        end
endmodule
