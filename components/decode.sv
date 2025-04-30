// Etapa: DECODE

module decode #(parameter N = 64, W_CSR = 8)
                    (input logic regWrite_D, clk,
                    input logic[2:0] Branch,
						  input logic branch_hazard,
                    input logic regSel0,
                    input logic weDB_D, csrDB_D,
						  input logic AluSrc,
                    input logic[11:0] csrAddrDB_D,
                    input logic[4:0] readRegDB_D, writeRegDB_D,
                    input logic[N-1:0] writeDataDB_D,
                    input logic[N-1:0] writeData3_D, PC_4, PC_D,
                    input logic[31:0] instr_D,
						  input logic[4:0] wa3_D,
                    input logic[N-1:0] csrOut[0:W_CSR-1],
						  input logic [1:0] fwA_Br, fwB_Br,
						  input logic[N-1:0] fwA_D, fwB_D,
                    output logic[N-1:0] signImm_D, csrRead_D,
                    output logic[N-1:0] readData1_D, readData2_D,
                    output logic[N-1:0] readDataDB_D,
						  output logic[4:0] rs1, rs2,
						  output logic[N-1:0] PCBranch_D,
						  output logic PCSrc_D,
						  output logic illegal_instr);
    
    logic[4:0] rs1_internal;
    logic[N-1:0] writeData3;
    logic[N-1:0] signImm, signedImm_PC;
    logic[N-1:0] jalrAddr;
    logic[N-1:0] readRegDataDB, readCSRDataDB, csrReadMux, writeMaskDBOut;
	 logic[N-1:0] readData1_internal, readData2_internal;
	 logic[N-1:0] readData1_Br, readData2_Br;
	 logic PCSrc;
    
    regfile	registers(.clk(~clk), 
                      .we3(regWrite_D | weDB_D), 
                      .wa3(weDB_D ? writeRegDB_D : wa3_D), // instr_D[11:7]),  // bits del registro
                      .ra1(rs1_internal), 
                      .ra2(instr_D[24:20]), 
                      .wd3(weDB_D ? writeMaskDBOut : writeData3), 
                      .rd1(readData1_internal), 
                      .rd2(readData2_internal),
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
    // assign writeData3 = (&{Branch[2:0]}) ? PC_4 : writeData3_D;
	 assign writeData3 = writeData3_D;
    assign rs1_internal = regSel0 ? 5'b0: instr_D[19:15];
	 
	 // Forwarding logic
    assign readData1_D = (rs1_internal == wa3_D && wa3_D != 5'b0) ? writeData3 : readData1_internal;
    assign readData2_D = (instr_D[24:20] == wa3_D && wa3_D != 5'b0) ? writeData3 : readData2_internal;
	 
	 // Enhanced branch forwarding logic
    // Priority: EX -> MEM -> WB -> Register File
    assign readData1_Br = (fwA_Br == 2'b10) ? fwA_D :        // Forward from EX/MEM
                         (fwA_Br == 2'b01) ? writeData3 :   // Forward from MEM/WB
                         readData1_D;                       // Default to register value

    assign readData2_Br = (fwB_Br == 2'b10) ? fwB_D :        // Forward from EX/MEM
                         (fwB_Br == 2'b01) ? writeData3 :   // Forward from MEM/WB
                         readData2_D;                       // Default to register value
	 
	 // assign readData1_Br = (fwA_Br != 2'b0 && Branch != 3'b0) ? fwA_D : readData1_D;
	 // assign readData2_Br = (fwB_Br != 2'b0 && Branch != 3'b0) ? fwB_D : readData2_D;
	 
	 // Assign internal signals to output ports
    assign rs1 = rs1_internal;
    assign rs2 = instr_D[24:20];
	 
	 // Branch signals
	 assign signedImm_PC = (signImm_D << 1);
    assign PCBranch_D  = AluSrc ? {signImm_D[N-1:1],1'b0} : signedImm_PC + PC_D;
	 
	 always_comb begin
	     case (Branch)
		      3'b001: PCSrc = (readData1_Br == readData2_Br);
				3'b011: PCSrc = (readData1_Br != readData2_Br);
				3'b101: PCSrc = ($signed(readData1_Br) < $signed(readData2_Br));
            3'b100: PCSrc = ($signed(readData1_Br) >= $signed(readData2_Br));
				3'b110: PCSrc = (readData1_Br < readData2_Br);   // BLTU
            3'b010: PCSrc = (readData1_Br >= readData2_Br);  // BGEU
            3'b111: PCSrc = 1'b1;  // Branch unconditionally
				default: PCSrc = 1'b0;
			endcase
	 end

	 always_comb begin
		  // Default to valid instruction
		  illegal_instr = 1'b0;

		  // Check for invalid opcodes or unsupported instructions
		  case (instr_D[6:0])
			   7'b0000011,  // Load instructions
			   7'b0100011,  // Store instructions
			   7'b0110011,  // R-type instructions
			   7'b0010011,  // I-type instructions
			   7'b1100011,  // Branch instructions
			   7'b1101111,  // JAL
			   7'b1100111,  // JALR
			   7'b1110011,  // System instructions (e.g., CSR, ECALL, EBREAK)
				7'b0000000:  // When initializing or stalling
					 illegal_instr = 1'b0;  // Valid opcode
			   default:
					 illegal_instr = 1'b1;  // Invalid opcode
		  endcase
	 end
	 
	 assign PCSrc_D = branch_hazard ? 1'b0 : PCSrc;

    // Coprocessor signals
    assign readDataDB_D = csrDB_D ? csrRead_D : readRegDataDB;
    wideXOR bitflip(.a(readRegDataDB),
                    .mask(writeDataDB_D),
                    .y(writeMaskDBOut));
endmodule
