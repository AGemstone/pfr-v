// Etapa: DECODE

module decode #(parameter N = 64, W_CSR = 8)
                    (input logic regWrite_D, clk,
                    input logic[2:0] Branch,
                    input logic regSel0,
                    input logic weDB_D, csrDB_D,
                    input logic[11:0] csrAddrDB_D,
                    input logic[4:0] readRegDB_D, writeRegDB_D,
                    input logic[N-1:0] writeDataDB_D,
                    input logic[N-1:0] writeData3_D, PC_4,
                    input logic[31:0] instr_D,
                    input logic[N-1:0] csrOut[0:W_CSR-1],
                    output logic[N-1:0] signImm_D, csrRead_D,
                    output logic[N-1:0] readData1_D, readData2_D,
                    output logic[N-1:0] readDataDB_D);
    
    logic[4:0] rs1;
    logic[N-1:0] writeData3;
    logic[N-1:0] signImm;
    logic[N-1:0] jalrAddr;
    logic[N-1:0] readRegDataDB, readCSRDataDB, csrReadMux, writeMaskDBOut;
    
    regfile	registers(.clk(clk), 
                      .we3(regWrite_D | weDB_D), 
                      .wa3(weDB_D ? writeRegDB_D : instr_D[11:7]), 
                      .ra1(rs1), 
                      .ra2(instr_D[24:20]), 
                      .wd3(weDB_D ? writeMaskDBOut : writeData3), 
                      .rd1(readData1_D), 
                      .rd2(readData2_D),
                      .ra_db(readRegDB_D),
                      .rd_db(readRegDataDB));

    signext ext(.a(instr_D), 
                .y(signImm));
    
    // Coprocessor can only read for now since it requires further changes
    csr_dec #(N, W_CSR, 0) csrD (.addr(csrDB_D ? csrAddrDB_D : instr_D[31:20]),
                                 .csr_out(csrOut),
                                 .csr_read(csrRead_D));

    // Early calculation of linked address (JALR)
    assign signImm_D = instr_D[6:0] == 7'b1100111 ? readData1_D + signImm : signImm;

    // Early write of return address
    assign writeData3 = (&{Branch[2:0]}) ? PC_4 : writeData3_D;
    assign rs1 = regSel0 ? 5'b0: instr_D[19:15];

    // Coprocessor signals
    assign readDataDB_D = csrDB_D ? csrRead_D : readRegDataDB;
    wideXOR bitflip(.a(readRegDataDB),
                    .mask(writeDataDB_D),
                    .y(writeMaskDBOut));
endmodule

