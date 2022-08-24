module mux3 #(
    parameter N = 64
) (
    input logic[N-1:0] d0, d1, d2,
    input logic[1:0] s,
    output logic [N-1:0] y
);
    always_comb
        case (s)
            'b10    : y = d2;
            'b01    : y = d1;
            'b00    : y = d0;
            default : y = '0;
        endcase
    
endmodule