	coprocessor u0 (
		.clk_clk                (<connected-to-clk_clk>),                //             clk.clk
		.pio_addr_export        (<connected-to-pio_addr_export>),        //        pio_addr.export
		.pio_control_export     (<connected-to-pio_control_export>),     //     pio_control.export
		.pio_data_high_in_port  (<connected-to-pio_data_high_in_port>),  //   pio_data_high.in_port
		.pio_data_high_out_port (<connected-to-pio_data_high_out_port>), //                .out_port
		.pio_data_low_in_port   (<connected-to-pio_data_low_in_port>),   //    pio_data_low.in_port
		.pio_data_low_out_port  (<connected-to-pio_data_low_out_port>),  //                .out_port
		.pio_riscv_flags_export (<connected-to-pio_riscv_flags_export>), // pio_riscv_flags.export
		.reset_reset_n          (<connected-to-reset_reset_n>)           //           reset.reset_n
	);

