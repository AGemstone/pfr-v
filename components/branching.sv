module branching(input logic[2:0] Branch_W,
				 input logic zero_W, sign_W, overflow_W,	
				 output logic PCSrc_W);
	always_comb
	case(Branch_W)
		3'b001 : PCSrc_W = zero_W;
		3'b011 : PCSrc_W = ~zero_W;

		3'b101 : PCSrc_W = sign_W & (~zero_W);
		3'b100 : PCSrc_W = (~sign_W) | zero_W;
		
		3'b110 : PCSrc_W = overflow_W & (~zero_W);
		3'b010 : PCSrc_W = (~overflow_W) | zero_W;
		
		3'b111 : PCSrc_W = 1;
		default PCSrc_W = 0;
	endcase
	
	
endmodule