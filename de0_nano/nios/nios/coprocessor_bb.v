
module coprocessor (
	clk_clk,
	pio_addr_export,
	pio_control_export,
	pio_data_high_in_port,
	pio_data_high_out_port,
	pio_data_low_in_port,
	pio_data_low_out_port,
	pio_riscv_flags_export,
	reset_reset_n);	

	input		clk_clk;
	output	[14:0]	pio_addr_export;
	output	[5:0]	pio_control_export;
	input	[31:0]	pio_data_high_in_port;
	output	[31:0]	pio_data_high_out_port;
	input	[31:0]	pio_data_low_in_port;
	output	[31:0]	pio_data_low_out_port;
	input	[1:0]	pio_riscv_flags_export;
	input		reset_reset_n;
endmodule
