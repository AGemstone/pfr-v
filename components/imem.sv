module imem #(parameter N = 32)(
    input logic[5:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 63];
    localparam int prog_leng = 13;
    assign rom[0:prog_leng-1] = '{
        'h00a50533,
        'h00a03023,
        'h00003583,
        'h40b685b3,
        'h00a5f633,
        'h00160633,
        'h00c03423,
        'h00a5e633,
        'h00160633,
        'h00c03823,
        'h00b51063,
        'h00000033,
        'h00a50063
    };
    assign rom [prog_leng:63] = '{(64-prog_leng){0}};
    assign q = rom[addr];
endmodule