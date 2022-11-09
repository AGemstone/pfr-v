module imem #(parameter N = 32)(
    input logic[5:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 63];
    localparam int prog_leng = 11;
    assign rom[0:prog_leng-1] = '{
        'h00000013, //   0: nop
        'h00000013, //   4: nop
        'h30045073, //   8: csrwi mstatus,8
        'h07000293, //   c: li t0,112
        'h30529073, //  10: csrw mtvec,t0
        'h00100073, //  14: ebreak
        'h00c0006f, //  18: j 24 <main>
        'h30002573, //  1c: csrr a0,mstatus
        'h30200073, //  20: mret
        'h30002573, //  24: csrr a0,mstatus
        'hfe000ee3  //  28: beqz zero,24 <main>
    };
    assign rom [prog_leng:63] = '{(64-prog_leng){'0}};
    assign q = rom[addr];
endmodule