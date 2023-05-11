module dmem #(parameter N=64,M=32) 
            (input logic clk,reset,
            input logic[N-1:0] writeData,
            input logic[11:0] wordAddr,
            input logic readEnable,
            input logic writeEnable,
            input logic[2:0] memWidth,
            input logic[2:0] byteOffset,
            // input logic [M-1:0] IM_readData,
            // input logic dataSelect,
            output logic[N-1:0] readData);

    logic [N-1:0] DM_readData, readROMData, DM_writeData;
    logic [7:0] DM_writeMask;
    memWriteMask MEMWRITE_MASK(.select(byteOffset),
                               .memWidth(memWidth),
                               .DM_writeData(writeData),
                               .DM_writeData_M(DM_writeData),
                               .byteenable(DM_writeMask));
    
    // dmemip m9kmem(.clock(clk),
    //               .data(DM_writeData),
    //               .address(wordAddr),
    //               .rden(readEnable),
    //               .byteena(DM_writeMask),
    //               .wren(writeEnable),
    //               .q(DM_readData));

    altsyncram #(.operation_mode                ("SINGLE_PORT"),
                 .byte_size                     (8),
                 .width_byteena_a               (8),
                 .width_a                       (64),
                 .widthad_a                     (12),
                 .numwords_a                    (4096),
                 .outdata_reg_a                 ("UNREGISTERED"),
                 .init_file                     ("dmem_init.hex"),
                 .power_up_uninitialized        ("FALSE"),
                 .clock_enable_input_a          ("BYPASS" ),
                 .clock_enable_output_a         ("BYPASS"),
                 .intended_device_family        ("Cyclone IV E"),
                 .read_during_write_mode_port_a ("NEW_DATA_WITH_NBE_READ")) 
                 altdmem  (.clock0(clk),
                        .data_a(DM_writeData),
                        .address_a(wordAddr),
                        .rden_a(readEnable),
                        .byteena_a(DM_writeMask),
                        .wren_a(writeEnable),
                        .q_a(DM_readData),
				        .clocken0 (1'b1));

    // assign readROMData = {{(N-M){1'b0}}, IM_readData};
    // assign readData = dataSelect ? readROMData : DM_readData;
    // always @(posedge clk) begin
    // end
    assign readData = DM_readData;

endmodule