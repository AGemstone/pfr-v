module imem #(parameter N = 32)(
    input logic[5:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 63];
    assign rom[0:46] = '{
        'h00003023, //   0: sd zero,0(zero) # 0 <start>
        'h00000f93, //   4: li t6,0
        'h40000113, //   8: li sp,1024
        'h0600006f, //   c: j 6c <main>
        'hfd010113, //  10: addi sp,sp,-48
        'h02813423, //  14: sd s0,40(sp)
        'h03010413, //  18: addi s0,sp,48
        'hfca43c23, //  1c: sd a0,-40(s0)
        'hfe043423, //  20: sd zero,-24(s0)
        'h00100793, //  24: li a5,1
        'hfef43023, //  28: sd a5,-32(s0)
        'h0200006f, //  2c: j 4c <sum+0x3c>
        'hfe843703, //  30: ld a4,-24(s0)
        'hfe043783, //  34: ld a5,-32(s0)
        'h00f707b3, //  38: add a5,a4,a5
        'hfef43423, //  3c: sd a5,-24(s0)
        'hfe043783, //  40: ld a5,-32(s0)
        'h00178793, //  44: addi a5,a5,1
        'hfef43023, //  48: sd a5,-32(s0)
        'hfe043703, //  4c: ld a4,-32(s0)
        'hfd843783, //  50: ld a5,-40(s0)
        'hfce7fee3, //  54: bgeu a5,a4,30 <sum+0x20>
        'hfe843783, //  58: ld a5,-24(s0)
        'h00078513, //  5c: mv a0,a5
        'h02813403, //  60: ld s0,40(sp)
        'h03010113, //  64: addi sp,sp,48
        'h00008067, //  68: ret
        'hfe010113, //  6c: addi sp,sp,-32
        'h00113c23, //  70: sd ra,24(sp)
        'h00813823, //  74: sd s0,16(sp)
        'h02010413, //  78: addi s0,sp,32
        'h00400513, //  7c: li a0,4
        'hf91ff0ef, //  80: jal ra,10 <sum>
        'hfea43423, //  84: sd a0,-24(s0)
        'h00100f93, //  88: li t6,1
        'h01f03023, //  8c: sd t6,0(zero) # 0 <start>
        'h00000013, //  90: nop
        'hffdff06f, //  94: j 90 <main+0x24>
        'h00050613, //  98: mv a2,a0
        'h00000513, //  9c: li a0,0
        'h0015f693, //  a0: andi a3,a1,1
        'h00068463, //  a4: beqz a3,ac <__muldi3+0x14>
        'h00c50533, //  a8: add a0,a0,a2
        'h0015d593, //  ac: srli a1,a1,0x1
        'h00161613, //  b0: slli a2,a2,0x1
        'hfe0596e3, //  b4: bnez a1,a0 <__muldi3+0x8>
        'h00008067  //  b8: ret
    };
    assign rom [47:63] = '{(64-47){'0}};
    assign q = rom[addr];
endmodule