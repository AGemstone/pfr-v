module forwarding (
    input logic EX_MEM_RegWrite, MEM_WB_RegWrite,
    input logic EX_MEM_MemRead,  // Add this to identify load instructions
    input logic [4:0] EX_MEM_RegisterRd, MEM_WB_RegisterRd,
    input logic [4:0] ID_EX_RegisterRs1, ID_EX_RegisterRs2,

    output logic [1:0] fwA,
    output logic [1:0] fwB
);
    // Forwarding for operand A (rs1)
    always_comb begin
        // EX hazard (highest priority)
        if (EX_MEM_RegWrite && 
            (EX_MEM_RegisterRd != 0) && 
            (EX_MEM_RegisterRd == ID_EX_RegisterRs1)) begin
            fwA = 2'b10;  // Forward from EX/MEM pipeline register
        end
        // MEM hazard (lower priority)
        else if (MEM_WB_RegWrite && 
                (MEM_WB_RegisterRd != 0) && 
                (MEM_WB_RegisterRd == ID_EX_RegisterRs1)) begin
            fwA = 2'b01;  // Forward from MEM/WB pipeline register
        end
        else begin
            fwA = 2'b00;  // No forwarding (use register file value)
        end
    end

    // Forwarding for operand B (rs2) - same logic as for A
    always_comb begin
        if (EX_MEM_RegWrite && 
            (EX_MEM_RegisterRd != 0) && 
            (EX_MEM_RegisterRd == ID_EX_RegisterRs2)) begin
            fwB = 2'b10;
        end
        else if (MEM_WB_RegWrite && 
                (MEM_WB_RegisterRd != 0) && 
                (MEM_WB_RegisterRd == ID_EX_RegisterRs2)) begin
            fwB = 2'b01;
        end
        else begin
            fwB = 2'b00;
        end
    end
endmodule