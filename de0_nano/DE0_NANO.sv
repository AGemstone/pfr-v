//DE0_NANO_PipelinedProcessorPatterson
//Proyecto para mostrar por los led de la placa DE0 NANO
//el contenido de la posición "0" de la memoria de datos

module DE0_NANO (input logic [1:0] KEY,
                 input logic CLOCK_50,
                 output logic [7:0] LED
                //  // ram
                //  inout logic[15:0] DRAM_DQ,
                //  output logic[12:0] DRAM_ADDR,
                //  output logic[1:0] DRAM_BA,
                //  output logic DRAM_CAS_N,
                //  output logic DRAM_CKE,
                //  output logic DRAM_CLK,
                //  output logic DRAM_CS_N,
                //  output logic[1:0] DRAM_DQM,
                //  output logic DRAM_RAS_N,
                //  output logic DRAM_WE_N,
                //  //accelerometer
                //  input logic G_SENSOR_INT,
                //  output logic G_SENSOR_CS_N,
                //  output logic I2C_SCLK,
                //  inout logic I2C_SDAT
                 );

    logic [31:0] nios2IODataIn_L, nios2IODataIn_H, nios2IODataOut_L, nios2IODataOut_H;
    logic [14:0] nios2IOAddr;
    // ebreak, cycle_stall
    logic [1:0] nios2IORiscVFlags;
    
    logic DM_writeEnable, DM_readEnable;
    
    logic nios_reset_n;
    // mem_we, mem_re, reg_we
    logic [5:0] nios2IOControl;

    logic [63:0] DM_writeData, DM_addr, DM_readData;
    logic clk, clk_ram;
    logic [63:0] led;
    logic led_enable;
    
    
    coprocessor nios2 (.clk_clk(clk),           
                       .reset_reset_n(KEY[0]),    
		               .pio_data_high_in_port(nios2IODataIn_H),  
		               .pio_data_high_out_port(nios2IODataOut_H), 
		               .pio_data_low_in_port(nios2IODataIn_L),
		               .pio_data_low_out_port(nios2IODataOut_L),
                       .pio_addr_export(nios2IOAddr),
		               .pio_control_export(nios2IOControl),
                       .pio_riscv_flags_export(nios2IORiscVFlags));
    

    core #(64) core0(.clk(clk),
                     .reset(nios2IOControl[0] | ~KEY[1]),
                     .DM_readData(DM_readData),
                     .DM_writeData(DM_writeData),
                     .DM_addr(DM_addr),
                     .DM_writeEnable(DM_writeEnable),
                     .DM_readEnable(DM_readEnable),
                     .coprocessorIOAddr(nios2IOAddr),
                     .coprocessorIOControl(nios2IOControl[5:1]),
                     .coprocessorIODataOut({nios2IODataOut_H,nios2IODataOut_L}),
                     .coprocessorIODataIn({nios2IODataIn_H,nios2IODataIn_L}),
                     .coprocessorIODebugFlags(nios2IORiscVFlags));


    slow_clock clockpll (.inclk0(CLOCK_50),
                         .c0(clk));
    
    // clkDiv #(21) cD (.clk (CLOCK_50),
    //                  .reset (~KEY[0]),
    //                  .clkDiv (clk_very_slow));

    // clkDiv cD_ram #(22)(.clk (clk_ram),
    //                     .reset (~KEY[0]),
    //                     .clkDiv (clk_ram));
    
    // memControl ram(.clk(clk_ram),
    //                .dataAddr(DM_addr[21:4]),
    //                .bankSel(DRAM_BA),
    //                .CAS_N(DRAM_CAS_N),
    //                .dataMask(DRAM_DQM),
    //                .CS_N(DRAM_CS_N),
    //                .RAS_N(DRAM_RAS_N),
    //                .WE_N(DRAM_WE_N),
    //                .dramData(DRAM_DQ),
    //                .dramAddr(DRAM_ADDR),
    //                .dataWrite(DM_writeData),
    //                .dataRead(DM_readData),
    //                .op({DM_readEnable, DM_writeEnable})
    //                );
    // assign DRAM_CKE = 'b1;
    // assign DRAM_CLK = clk_ram;

    // First byte
    assign LED = led[7:0];
    // assign memOp = ;
    // Clock test
    //assign LED[7] = clk & clk_ram;
    //assign LED[6:2] = 'b0;
    //assign LED[1] = clk_ram;
    //assign LED[0] = clk;
    
    always_comb
    if ((DM_writeEnable == 1'b1) & (DM_addr == 64'b0)) 
        led_enable = 1'b1;
    else 
        led_enable = 1'b0;
    
    always_ff @(posedge clk)
        if (led_enable == 1'b1) 
            led = DM_writeData;		
endmodule 

