module signext (
    input logic[31: 0] a,
	 output logic[63:0] y
);

    always_comb
        // ld or sd 
        if (a[6:0] == 7'b0000011 | a[6:0] == 7'b0100011) 
            y = {{52{a[31]}}, {a[31:25], a[11:7]}};
        // SB format
        else if (a[31:24] == 7'b1100011) 
            y = { {50{a[31]}}, {a[31], a[7], a[30:25], a[11:6]}};
        // I Format
        else if (a[6:0] == 7'b0011011)
            y = {{52{1'b0}}, a[31:20]}; 
        else 
            y = {{32{a[31]}}, a};

endmodule