module imem #(parameter N = 32)(
    input logic[5:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 63];
    localparam int prog_leng = 59;
    assign rom[0:prog_leng-1] = '{
        'hff010113, //   0: addi sp,sp,-16
        'h00113423, //   4: sd ra,8(sp)
        'h00813023, //   8: sd s0,0(sp)
        'h01010413, //   c: addi s0,sp,16
        'h088000ef, //  10: jal ra,98 <main>
        'h00000013, //  14: nop
        'hffdff06f, //  18: j 14 <_start+0x14>
        'hfd010113, //  1c: addi sp,sp,-48
        'h02813423, //  20: sd s0,40(sp)
        'h03010413, //  24: addi s0,sp,48
        'hfca43c23, //  28: sd a0,-40(s0)
        'hfcb43823, //  2c: sd a1,-48(s0)
        'hfe043423, //  30: sd zero,-24(s0)
        'hfe043023, //  34: sd zero,-32(s0)
        'h0200006f, //  38: j 58 <mul+0x3c>
        'hfd843783, //  3c: ld a5,-40(s0)
        'hfe843703, //  40: ld a4,-24(s0)
        'h00f707b3, //  44: add a5,a4,a5
        'hfef43423, //  48: sd a5,-24(s0)
        'hfe043783, //  4c: ld a5,-32(s0)
        'h00178793, //  50: addi a5,a5,1
        'hfef43023, //  54: sd a5,-32(s0)
        'hfd043783, //  58: ld a5,-48(s0)
        'hfe043703, //  5c: ld a4,-32(s0)
        'hfcf76ee3, //  60: bltu a4,a5,3c <mul+0x20>
        'hfe843783, //  64: ld a5,-24(s0)
        'h00078513, //  68: mv a0,a5
        'h02813403, //  6c: ld s0,40(sp)
        'h03010113, //  70: addi sp,sp,48
        'h00008067, //  74: ret
        'hfe010113, //  78: addi sp,sp,-32
        'h00813c23, //  7c: sd s0,24(sp)
        'h02010413, //  80: addi s0,sp,32
        'hfea43423, //  84: sd a0,-24(s0)
        'h00000013, //  88: nop
        'h01813403, //  8c: ld s0,24(sp)
        'h02010113, //  90: addi sp,sp,32
        'h00008067, //  94: ret
        'hfd010113, //  98: addi sp,sp,-48
        'h02113423, //  9c: sd ra,40(sp)
        'h02813023, //  a0: sd s0,32(sp)
        'h03010413, //  a4: addi s0,sp,48
        'h00600793, //  a8: li a5,6
        'hfef43423, //  ac: sd a5,-24(s0)
        'h00500793, //  b0: li a5,5
        'hfef43023, //  b4: sd a5,-32(s0)
        'h00100073, //  b8: ebreak
        'hfe043583, //  bc: ld a1,-32(s0)
        'hfe843503, //  c0: ld a0,-24(s0)
        'hf59ff0ef, //  c4: jal ra,1c <mul>
        'hfca43c23, //  c8: sd a0,-40(s0)
        'hfd843503, //  cc: ld a0,-40(s0)
        'hfa9ff0ef, //  d0: jal ra,78 <dummy>
        'h00000793, //  d4: li a5,0
        'h00078513, //  d8: mv a0,a5
        'h02813083, //  dc: ld ra,40(sp)
        'h02013403, //  e0: ld s0,32(sp)
        'h03010113, //  e4: addi sp,sp,48
        'h00008067  //  e8: ret
    };
    assign rom [prog_leng:63] = '{(64-prog_leng){'0}};
    assign q = rom[addr];
endmodule