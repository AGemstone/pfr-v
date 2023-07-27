// CLOCK DIVIDER

module clkDiv #(parameter N = 24) (input logic clk,
					input logic reset,
					output logic clkDiv);
	
	logic [N:0] clk_divider;
	
	always_ff @(posedge clk, posedge reset)
		if(reset) clk_divider  <= 'b0;
		else clk_divider <= clk_divider + 1;
		
	// Para analizar en modelSim:	
	// assign clkDiv = clk_divider[0];

	// Para grabar en FPGA:
	assign clkDiv = clk_divider[N];

endmodule 