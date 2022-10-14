// Etapa: DECODE

module decode #(parameter N = 64)
                    (input logic regWrite_D, clk,
                    input logic[2:0] Branch,
                    input logic regSel0,
                    input logic[N-1:0] writeData3_D, PC_4,
                    input logic[31:0] instr_D,
                    output logic[N-1:0] signImm_D,
                    output logic[N-1:0] readData1_D, readData2_D);
    

    
    logic[4:0] rs1;
    logic[N-1:0] writeData3;
    
    regfile	registers(.clk(clk), 
                      .we3(regWrite_D), 
                      .wa3(instr_D[11:7]), 
                      .ra1(rs1), 
                      .ra2(instr_D[24:20]), 
                      .wd3(writeData3), 
                      .rd1(readData1_D), 
                      .rd2(readData2_D));

    signext ext(.a(instr_D), 
                .y(signImm_D));

    // Early write of return address
    assign writeData3 = (&{Branch[2:0]}) ? PC_4 : writeData3_D;
    assign rs1 = regSel0 ? 5'b0: instr_D[19:15];

endmodule
