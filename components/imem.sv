module imem #(parameter N = 32)(
    input logic[5:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 63];
    localparam int prog_leng = 16;
    assign rom[0:prog_leng-1] = '{
        'h00000013, //   0: nop
        'h00000013, //   4: nop
        'h30046073, //   8: csrsi mstatus,8
        'h00051c63, //   c: bnez a0,24 <hoop>
        'h02c00293, //  10: li t0,44
        'h00229293, //  14: slli t0,t0,0x2
        'h30529073, //  18: csrw mtvec,t0
        'h00100513, //  1c: li a0,1
        'h30200073, //  20: mret
        'h00100073, //  24: ebreak
        'h00c0006f, //  28: j 34 <main>
        'h00000013, //  2c: nop
        'h30200073, //  30: mret
        'h30002573, //  34: csrr a0,mstatus
        'h00000013, //  38: nop
        'hfe000ce3  //  3c: beqz zero,34 <main>
    };
    assign rom [prog_leng:63] = '{(64-prog_leng){'0}};
    assign q = rom[addr];
endmodule