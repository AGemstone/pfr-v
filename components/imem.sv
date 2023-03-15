module imem #(parameter N = 32)(
    input logic[5:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 63];
    localparam int prog_leng = 7;
    assign rom[0:prog_leng-1] = '{
        'h0ff00593, //   0: li a1,255
        'h00000533, //   4: add a0,zero,zero
        'h00150513, //   8: addi a0,a0,1
        'h00050513, //   c: mv a0,a0
        'h00a03023, //  10: sd a0,0(zero) # 0 <setup>
        'hfeb51ae3, //  14: bne a0,a1,8 <loop>
        'hfe0006e3  //  18: beqz zero,4 <start>
    };
    assign rom [prog_leng:63] = '{(64-prog_leng){'0}};
    assign q = rom[addr];
endmodule