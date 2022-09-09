module mulCell(
    input logic a, b, c, cin,
    output logic y, cout
);
    add1bit mcell (.a(a & b),
                  .b(c),
                  .y(y),
                  .cin(cin),
                  .cout(cout)
                 );

endmodule
