module signext (
    input logic[31: 0] a,
	 output logic[63:0] y
);

    always_comb
        // S format (stores)
        if (a[6:0] == 7'b0100011) 
            y = {{52{a[31]}}, {a[31:25]},{a[11:7]}};
        // B format (Branch)
        else if (a[6:0] == 7'b1100011)
            y = { {52{a[31]}}, {a[31], a[7], a[30:25], a[11:8]}};
        // I format
        else if ((a[6:0] == 7'b0010011) |  // imm arithmetic
                 (a[6:0] == 7'b1100111) |  // JALR
                 (a[6:0] == 7'b0000011))   // loads
            y = {{52{a[31]}}, a[31:20]}; 
        
        // JAL
        else if (a[6:0] == 7'b1101111)
            y = {{44{a[31]}}, {a[31], a[19:12], a[20], a[30:21]}};
               
        else if ((a[6:0] == 7'b0110111) | // LUI
                 (a[6:0] == 7'b0010111))  // AUIPC
            y = {{32{a[31]}}, a[31:12], {12'b0}};
        
        // I-32 format
        else if (a[6:0] == 7'b0011011)
            y = {{32'b0},{20{a[31]}}, a[31:20]};
        
        // System
        else if (a[6:0] == 7'b1110011)
            y = {{59{a[19]}}, a[19:15]};

        else 
            y = {{32{a[31]}}, a};
        
endmodule