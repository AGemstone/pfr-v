// PIPELINED PROCESSOR

module core #(parameter N = 64)
                            (input logic CLOCK_50, reset,
                            input logic[N-1:0] DM_readData,
                            output logic [N-1:0] DM_writeData, DM_addr,
                            output logic DM_writeEnable, DM_readEnable,
                            input logic dump);
                            
    logic[31:0] q;		
    logic[3:0] AluControl;
    logic regWrite, memtoReg, memWrite, AluSrc, wArith;
    logic[1:0] regSel, memRead;
    logic[2:0] Branch, memMask;
    logic[N-1:0] readData, IM_address;
    logic[N-1:0] PC_Trap;
    logic[3:0] exceptSignal_F;
    logic[2:0] exceptSignal_D;
    logic[6:0] exceptSignal_E;
    logic[15:0] exceptSignal;
    logic[15:0] interruptSignal;
    logic[N-1:0] mip, mie;
    logic[2:0] breakSrc;
    logic[16:0] instr;
    logic [N-1:0] mstatusIn, mstatusOut;
    logic mIEToggle;

    // Not yet implemented
    flopre_init #(64) mstatus_csr(.clk(CLOCK_50),
                                  .reset(reset),
                                  .d({{(N-4){1'b0}}, 
                                      ~mstatus[3],
                                      {3'b0}}),
                                  .enable(1'b0),
                                  .q(mstatus));

    flopre_init #(64) mstatus_csr(.clk(CLOCK_50),
                                  .reset(reset),
                                  .d({{(N-4){1'b0}}, 
                                      ~mstatus[3],
                                      {3'b0}}),
                                  .enable(1'b0),
                                  .q(mstatus));                            

    // no interrupt support for now
    // order of except signal is according to except code
    // reserved signals are grounded
    except_controller eC(.privMode(2'b00),
                         .nextPriv(2'b00),
                         .exceptSignal(exceptSignal),
                         .interruptSignal(interruptSignal),
                         .PC_F(IM_address),
                         .breakSrc(breakSrc),
                         .PC_Trap(PC_Trap),
                         .MIE(mstatus[3]),
                         .async(1'b0),
                         .mIEToggle(mIEToggle),
                         .clk(CLOCK_50),
                         .reset(reset));

    controller c(.funct12(q[31:20]),
                 .funct3(q[14:12]), 
                 .instr(q[6:0]),
                 .AluControl(AluControl), 
                 .regWrite(regWrite), 
                 .AluSrc(AluSrc), 
                 .regSel(regSel),
                 .Branch(Branch),
                 .wArith(wArith),
                 .memMask(memMask),
                 .memtoReg(memtoReg), 
                 .memRead(memRead),
                 .breakSrc(breakSrc[2]),
                 .exceptSignal_D(exceptSignal_D),
                 .memWrite(memWrite));                    
                    
    datapath #(64) dp(.reset(reset), 
                      .clk(CLOCK_50), 
                      .AluSrc(AluSrc), 
                      .regSel(regSel),
                      .AluControl(AluControl), 
                      .Branch(Branch), 
                      .wArith(wArith),
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
                      .DM_readEnable(DM_readEnable),
                      .exceptSignal_F(exceptSignal_F),
                      .exceptSignal_E(exceptSignal_E),
                      .PC_Trap(PC_Trap),
                      .breakSrc(breakSrc[1:0])
                    //   .PC_F(PC),
                      );				
                      
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

    dmemip dataMem(.clock(CLOCK_50),
	                 .data(DM_writeData),
	                 .address(DM_addr[12:3]),
	                 .rden(DM_readEnable),
	                 .wren(DM_writeEnable),
	                 .q(readData));
  
  assign exceptSignal = {exceptSignal_E[5],
                        {1'b0},
                        exceptSignal_E[4],
                        exceptSignal_F[2],
                        exceptSignal_D[1],
                        {1'b0}, 
                        exceptSignal_D[1], 
                        exceptSignal_D[1], 
                        exceptSignal_E[3:0],
                        {(exceptSignal_E[5] | exceptSignal_D[0] | except_F[2])},
                        exceptSignal_D[2], 
                        exceptSignal_F[1:0]};
  assign interruptSignal = 'b0;
	assign mstatusIn = {{42'b0}, 
                      {1'b0}, 
                      {3'b0}, 
                      mprv, 
                      {4'b0}, 
                      mpp, 
                      {3'b0}, 
                      mpie,
                      {3'b0},
                      mie, 
                      {4'b0}};
endmodule