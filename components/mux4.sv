module mux4 #(
    parameter N=16
) (
    input logic [1:0] s,
    input logic [N-1:0] d0,
    input logic [N-1:0] d1,
    input logic [N-1:0] d2,
    input logic [N-1:0] d3,
    output logic [N-1:0] y
);
    always_comb
    case(s)
        2'b00: y = d0; 
        2'b01: y = d1; 
        2'b10: y = d2; 
        2'b11: y = d3; 
        default y = d0;
    endcase
endmodule