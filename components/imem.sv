module imem #(parameter N = 32)(
    input logic[9:0] addr0,
    output logic[N-1:0] q0
);
    logic [N - 1:0] rom0 [0 : 1023];

    initial begin
        $readmemh("imem_init.txt", rom0);
    end
    assign q0 = rom0[addr0];
    // altsyncram #(.operation_mode                ("SINGLE_PORT"),
    //              .byte_size                     (8),
    //              .width_a                       (32),
    //              .widthad_a                     (10),
    //              .numwords_a                    (1024),
    //              .outdata_reg_a                 ("UNREGISTERED"),
    //              .init_file                     ("imem_init.hex"),
    //              .power_up_uninitialized        ("FALSE"),
    //              .clock_enable_input_a          ("BYPASS" ),
    //              .clock_enable_output_a         ("BYPASS"),
    //              .intended_device_family        ("Cyclone IV E"),
    //              .read_during_write_mode_port_a ("NEW_DATA_WITH_NBE_READ")) 
    //              altimem (.clock0(clk),
    //                       .address_a(addr0),
    //                       .rden_a(1'b1),
    //                       .clocken0 (1'b1),
    //                       .q_a(q0));
endmodule