module signext (
    input logic[31: 0] a,
	 output logic[63:0] y
);

    always_comb
        // LDUR or STUR
        if (a[31:21] == 11'b111_1100_0010 | 
            a[31:21] == 11'b111_1100_0000) 
            y = {{55{a[20]}}, a[20:12]};
        // CBZ or CBNZ
        else if (a[31:24] == 8'b101_1010_0 |
                 a[31:24] == 8'b101_1010_1) 
            y = {{43{a[23]}}, a[23:5], 2'b00};
        // I Format
        else if (a[31:22] == 10'b1001_0001_00 |
                 a[31:22] == 10'b1101_0001_00) 
            y = {{52{1'b0}}, a[21:10]}; 
        else 
            y = {{32{a[31]}}, a};

endmodule
