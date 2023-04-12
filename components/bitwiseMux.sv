module bitwiseMux #(parameter N = 64)
                    (input logic[N-1:0] a,b,s,
                    output logic [N-1:0] y);
    assign y = (a & ~s) | (b & s);
endmodule