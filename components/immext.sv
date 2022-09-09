module immext (
    input logic[31: 0] a,
	 output logic[63:0] y
);

    // defines if zero or sign extended
    logic[2:0] funct3;
    always_comb

        // sd
        if (a[6:0] == 7'b0100011) 
            y = {{52{a[31]}}, {a[31:25]},{a[11:7]}};
        // SB format (Branch)
        else if (a[6:0] == 7'b1100011) 
            y = { {52{a[31]}}, {a[31], a[7], a[30:25], a[11:8]}};
        // I Format or ld
        else if ((a[6:0] == 7'b0010011) | (a[6:0] == 7'b0000011))
            y = {{52{a[31]}}, a[31:20]}; 
        else if (a[6:0] == 7'b1101111)
            y = {{32{a[31]}}, {a[31], a[19:12], a[20], a[30:21]}};
    
        else if (a[6:0] == 7'b0110111 | a[6:0] == 7'b0010111) 
            y = {{32'b0}, a[31:12], {12'b0}};
        
        else 
            y = {{32{a[31]}}, a};
        
    assign funct3 = a[14:12];
endmodule