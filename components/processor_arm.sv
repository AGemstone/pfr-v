// PIPELINED PROCESSOR

module processor_arm #(parameter N = 64)
                            (input logic CLOCK_50, reset,
                            output logic [N-1:0] DM_writeData, DM_addr,
                            output logic DM_writeEnable,
                            input	logic dump,
                            // output logic [16:0] current_inst,
                            // output logic Zero_Flag,
                            output logic [31:0] opcode,
                            output logic [9:0] control
                            );
                            
    logic[31:0] q;		
    logic[3:0] AluControl;
    logic regWrite, memtoReg, memRead, memWrite, AluSrc;
    logic[1:0] regSel;
    logic[2:0] Branch;
    logic[N-1:0] DM_readData, IM_address;  //DM_addr, DM_writeData
    logic DM_readEnable; //DM_writeEnable
    logic[16:0] instr;

    controller 	c(.funct7(q[31:25]),
                  .funct3(q[14:12]), 
                  .instr(q[6:0]),
                  .AluControl(AluControl), 
                  .regWrite(regWrite), 
                  .AluSrc(AluSrc), 
                  .regSel(regSel),
                  .Branch(Branch),
                  .memtoReg(memtoReg), 
                  .memRead(memRead), 
                  .memWrite(memWrite));                    
                    
    datapath #(64) dp (.reset(reset), 
                       .clk(CLOCK_50), 
                       .AluSrc(AluSrc), 
                       .regSel(regSel),
                       .AluControl(AluControl), 
                       .Branch(Branch), 
                       .memRead(memRead),
                       .memWrite(memWrite), 
                       .regWrite(regWrite), 
                       .memtoReg(memtoReg), 
                       .IM_readData(q), 
                       .DM_readData(DM_readData), 
                       .IM_addr(IM_address), 
                       .DM_addr(DM_addr), 
                       .DM_writeData(DM_writeData), 
                       .DM_writeEnable(DM_writeEnable), 
                       .DM_readEnable(DM_readEnable));				
             
                    
    imem 				instrMem (.addr(IM_address[7:2]),
                                  .q(q));
                                    
    
    dmem 				dataMem 	(.clk(CLOCK_50), 
                                     .memWrite(DM_writeEnable), 
                                     .memRead(DM_readEnable), 
                                     .address(DM_addr[8:3]), 
                                     .writeData(DM_writeData), 
                                     .readData(DM_readData), 
                                     .dump(dump)); 	
    // assign current_inst = instr;
    assign opcode = q;
    assign control = {regSel, AluSrc, memtoReg, regWrite, memRead, memWrite, 
                      Branch};
         
endmodule
