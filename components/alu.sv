module alu #(
    parameter N=64
) (
    input logic[N-1:0] a, b,
    input logic[3:0] ALUControl,
    output logic zero,
    output logic[N-1:0] result
);

    always_comb
    case(ALUControl) 
        4'b0000 : result = a & b;
        4'b0001 : result = a | b;
        4'b0010 : result = a + b;
        4'b0110 : result = a - b;
        4'b0111 : result = b;
        4'b1100 : result = ~(a | b);
        default result = b;
    endcase
        assign zero = ~(|{N{result}});
endmodule