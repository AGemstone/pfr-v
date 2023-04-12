module imem #(parameter N = 32)(
    input logic[5:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 63];
    assign rom[0:53] = '{
        'h00003023, //   0: sd zero,0(zero) # 0 <start>
        'h00000f93, //   4: li t6,0
        'h40000113, //   8: li sp,1024
        'h0940006f, //   c: j a0 <kmain>
        'hfd010113, //  10: addi sp,sp,-48
        'h02813423, //  14: sd s0,40(sp)
        'h00000013, //  18: nop
        'h03010413, //  1c: addi s0,sp,48
        'hfca43c23, //  20: sd a0,-40(s0)
        'h00000013, //  24: nop
        'hfe043423, //  28: sd zero,-24(s0)
        'h00000013, //  2c: nop
        'h00100793, //  30: li a5,1
        'hfef43023, //  34: sd a5,-32(s0)
        'h00000013, //  38: nop
        'h0340006f, //  3c: j 70 <sum+0x60>
        'hfe843703, //  40: ld a4,-24(s0)
        'hfe843703, //  44: ld a4,-24(s0)
        'hfe043783, //  48: ld a5,-32(s0)
        'hfe043783, //  4c: ld a5,-32(s0)
        'h00f707b3, //  50: add a5,a4,a5
        'hfef43423, //  54: sd a5,-24(s0)
        'h00000013, //  58: nop
        'hfe043783, //  5c: ld a5,-32(s0)
        'hfe043783, //  60: ld a5,-32(s0)
        'h00178793, //  64: addi a5,a5,1
        'hfef43023, //  68: sd a5,-32(s0)
        'h00000013, //  6c: nop
        'hfe043703, //  70: ld a4,-32(s0)
        'hfe043703, //  74: ld a4,-32(s0)
        'hfd843783, //  78: ld a5,-40(s0)
        'hfd843783, //  7c: ld a5,-40(s0)
        'hfcf760e3, //  80: bltu a4,a5,40 <sum+0x30>
        'hfe843783, //  84: ld a5,-24(s0)
        'hfe843783, //  88: ld a5,-24(s0)
        'h00078513, //  8c: mv a0,a5
        'h02813403, //  90: ld s0,40(sp)
        'h02813403, //  94: ld s0,40(sp)
        'h03010113, //  98: addi sp,sp,48
        'h00008067, //  9c: ret
        'hfe010113, //  a0: addi sp,sp,-32
        'h00113c23, //  a4: sd ra,24(sp)
        'h00000013, //  a8: nop
        'h00813823, //  ac: sd s0,16(sp)
        'h00000013, //  b0: nop
        'h02010413, //  b4: addi s0,sp,32
        'h00500513, //  b8: li a0,5
        'hf55ff0ef, //  bc: jal ra,10 <sum>
        'hfea43423, //  c0: sd a0,-24(s0)
        'h00000013, //  c4: nop
        'h00100f93, //  c8: li t6,1
        'h01f03023, //  cc: sd t6,0(zero) # 0 <start>
        'h00000013, //  d0: nop
        'hffdff06f  //  d4: j d0 <kmain+0x30>
    };
    assign rom [54:63] = '{(64-54){'0}};
    assign q = rom[addr];
endmodule