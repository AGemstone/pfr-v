module wideXOR #(parameter N = 64)
                (input logic[N-1:0] a, mask,
                output logic [N-1:0] y);
        
    assign y = a ^ mask;
endmodule