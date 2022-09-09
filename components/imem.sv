module imem #(parameter N = 32)(
    input logic[5:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 63];
    localparam int prog_leng = 22;
    assign rom[0:prog_leng-1] = '{
        'h00000033,
        'h00000033,
        'h00a50533,
        'h00a03023,
        'h00003583,
        'h00158593,
        'h00a5f633,
        'h00c03423,
        'h00a5e6b3,
        'h00d03823,
        'hfff5f713,
        'h00e03c23,
        'hfff5e793,
        'h02f03023,
        'hf4240837,
        'h03003423,
        'hf4240897,
        'h03103823,
        'h00009463,
        'h00000033,
        'h00000063,
        'h00000033
    };
    assign rom [prog_leng:63] = '{(64-prog_leng){'0}};
    assign q = rom[addr];
endmodule