// PIPELINED PROCESSOR

module processor_arm #(parameter N = 64)
                            (input logic CLOCK_50, reset,
                            input logic[N-1:0] DM_readData,
                            output logic [N-1:0] DM_writeData, DM_addr,
                            output logic DM_writeEnable, DM_readEnable,
                            input logic dump);
                            
    logic[31:0] q;		
    logic[3:0] AluControl;
    logic regWrite, memtoReg, memWrite, AluSrc, w_arith;
    logic[1:0] regSel, memRead;
    logic[2:0] Branch, memMask;
    logic[N-1:0] readData, IM_address;  //DM_addr, DM_writeData
    
    logic[16:0] instr;

    controller c(.funct7(q[31:25]),
                 .funct3(q[14:12]), 
                 .instr(q[6:0]),
                 .AluControl(AluControl), 
                 .regWrite(regWrite), 
                 .AluSrc(AluSrc), 
                 .regSel(regSel),
                 .Branch(Branch),
                 .w_arith(w_arith),
                 .memMask(memMask),
                 .memtoReg(memtoReg), 
                 .memRead(memRead), 
                 .memWrite(memWrite));                    
                    
    datapath #(64) dp(.reset(reset), 
                      .clk(CLOCK_50), 
                      .AluSrc(AluSrc), 
                      .regSel(regSel),
                      .AluControl(AluControl), 
                      .Branch(Branch), 
                      .w_arith(w_arith),
                      .memMask(memMask),
                      .memRead(memRead),
                      .memWrite(memWrite), 
                      .regWrite(regWrite), 
                      .memtoReg(memtoReg), 
                      .IM_readData(q), 
                      .DM_readData(readData), 
                      .IM_addr(IM_address), 
                      .DM_addr(DM_addr), 
                      .DM_writeData(DM_writeData), 
                      .DM_writeEnable(DM_writeEnable), 
                      .DM_readEnable(DM_readEnable));				
                      
    imem instrMem (.addr(IM_address[7:2]),
                   .q(q));
                                    
    // dmem dataMem(.clk(CLOCK_50), 
    //              .memWrite(DM_writeEnable), 
    //              .memRead(DM_readEnable), 
    //              .address(DM_addr[9:3]), 
    //              .writeData(DM_writeData), 
    //              .readData(readData), 
    //              .dump(dump));
    // assign DM_readData = readData;

    dmemip dataMem(
	.clock(CLOCK_50),
	.data(DM_writeData),
	.address(DM_addr[12:3]),
	.rden(DM_readEnable),
	.wren(DM_writeEnable),
	.q(readData));
	
endmodule
