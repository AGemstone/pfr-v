// Etapa: DECODE

module decode #(parameter N = 64)
                    (input logic regWrite_D, clk,
                    input logic [N-1:0] writeData3_D,
                    input logic [31:0] instr_D,
                    output logic [N-1:0] signImm_D, readData1_D, readData2_D);
    
    regfile	registers(.clk(clk), 
                      .we3(regWrite_D), 
                      .wa3(instr_D[11:7]), 
                      .ra1(instr_D[19:15]), 
                      .ra2(instr_D[24:20]), 
                      .wd3(writeData3_D), 
                      .rd1(readData1_D), 
                      .rd2(readData2_D));

    signext ext	(.a(instr_D), 
                 .y(signImm_D));

endmodule
