module hazard (
    input logic clk, reset,
    input logic ID_EX_MemRead, PCSrc, ID_EX_PCSrc, interruptSignal_D, trapTrigger,
    input logic [2:0] IF_ID_Branch,
    input logic [4:0] ID_EX_RegisterRd, IF_ID_RegisterRs1, IF_ID_RegisterRs2, // ID_EX_RegisterRs1, ID_EX_RegisterRs2,
    input logic [4:0] EX_MEM_RegisterRd, // MEM_WB_RegisterRd,
	 output logic branch_hazard,
    output logic PCEnable, ControlEnable, IF_ID_writeEnable, IF_ID_reset,
    output logic [1:0] cnt
);
    logic [1:0] stall_counter = 0;
    logic branch_hazard_aux;

    assign branch_dep_EX = (IF_ID_Branch != 3'b000) &&
                         (ID_EX_RegisterRd != 5'b0) &&
                         ((IF_ID_RegisterRs1 == ID_EX_RegisterRd) || 
                          (IF_ID_RegisterRs2 == ID_EX_RegisterRd));
    assign branch_dep_MEM = (IF_ID_Branch != 3'b000) && 
                          (EX_MEM_RegisterRd != 5'b0) &&
                          ((IF_ID_RegisterRs1 == EX_MEM_RegisterRd) || 
                           (IF_ID_RegisterRs2 == EX_MEM_RegisterRd));
    // assign branch_dep_WB = (IF_ID_Branch != 3'b000) && 
    //                      (MEM_WB_RegisterRd != 5'b0) &&
    //                      ((IF_ID_RegisterRs1 == MEM_WB_RegisterRd) || 
    //                       (IF_ID_RegisterRs2 == MEM_WB_RegisterRd));
	 

	 // assign load_use_hazard = EX_MEM_MemRead && 
    //                    (EX_MEM_RegisterRd != 0) &&
    //                    ((ID_EX_RegisterRs1 == EX_MEM_RegisterRd) || 
    //                     (ID_EX_RegisterRs2 == EX_MEM_RegisterRd));

    assign branch_hazard_aux = (branch_dep_EX || branch_dep_MEM); // || branch_dep_WB);
	 
	 assign branch_hazard = branch_hazard_aux;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            stall_counter <= 0;
        end
        else if (branch_hazard_aux && stall_counter == 0) begin
            stall_counter <= (branch_dep_EX + branch_dep_MEM); // + branch_dep_WB - 1);
        end
        else if (stall_counter > 0) begin
            stall_counter <= stall_counter - 1;
        end
    end

    always_comb begin
		  if (ID_EX_MemRead & ((ID_EX_RegisterRd == IF_ID_RegisterRs1) | 
                            (ID_EX_RegisterRd == IF_ID_RegisterRs2))) begin
            PCEnable = 1'b0;
            ControlEnable = 1'b0;
            IF_ID_writeEnable = 1'b0;
        end
        else if (IF_ID_Branch != 3'b0 & (PCSrc == 1'b1 || branch_hazard_aux)) begin
            PCEnable = 1'b0;
            ControlEnable = 1'b0;
            IF_ID_writeEnable = 1'b0;
        end
        else if (stall_counter > 0) begin
            PCEnable = 1'b0;
            ControlEnable = 1'b0;
            IF_ID_writeEnable = 1'b0;
        end
		  else if (trapTrigger) begin
		      PCEnable = 1'b0;
            ControlEnable = 1'b0;
            IF_ID_writeEnable = 1'b0;
		  end
        else begin
            PCEnable = 1'b1;
            ControlEnable = 1'b1;
            IF_ID_writeEnable = 1'b1;
        end
    end

	 // assign ID_EX_writeEnable = ~load_use_hazard;
    assign cnt = stall_counter;
    assign IF_ID_reset = ID_EX_PCSrc || interruptSignal_D;
endmodule