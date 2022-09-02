module imem #(parameter N = 32)(
    input logic[5:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 63];
    localparam int prog_leng = 7;
    assign rom[0:prog_leng-1] = '{
        'h0ff00593,
        'h00000533,
        'h00150513,
        'h00050513,
        'h00a03023,
        'hfeb51ae3,
        'hfe0006e3
    };
    assign rom [prog_leng:63] = '{(64-prog_leng){'0}};
    assign q = rom[addr];
endmodule