module hazard (
    input logic ID_EX_MemRead,
    input logic[4:0] ID_EX_RegisterRd, IF_ID_RegisterRs1, IF_ID_RegisterRs2,
    output logic PCEnable, ControlEnable, IF_ID_writeEnable
);
    always_comb
        if (ID_EX_MemRead &
            ((ID_EX_RegisterRd == IF_ID_RegisterRs1) |
            (ID_EX_RegisterRd == IF_ID_RegisterRs2))) begin
                PCEnable = 1'b0;
                ControlEnable = 1'b0;
                IF_ID_writeEnable = 1'b0;
        end
        else begin
                PCEnable = 1'b1;
                ControlEnable = 1'b1;
                IF_ID_writeEnable = 1'b1;
        end
    
endmodule