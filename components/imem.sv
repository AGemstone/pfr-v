module imem #(parameter N = 32)(
    input logic[7:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 255];
    assign rom[0:133] = '{
        'h00003023, //   0: sd zero,0(zero) # 0 <start>
        'h00000f93, //   4: li t6,0
        'h40000113, //   8: li sp,1024
        'h1c40006f, //   c: j 1d0 <main>
        'hf6010113, //  10: addi sp,sp,-160
        'h08813c23, //  14: sd s0,152(sp)
        'h0a010413, //  18: addi s0,sp,160
        'hf6a43423, //  1c: sd a0,-152(s0)
        'hf6843783, //  20: ld a5,-152(s0)
        'h0007b023, //  24: sd zero,0(a5)
        'h0007b423, //  28: sd zero,8(a5)
        'h0007b823, //  2c: sd zero,16(a5)
        'h0007bc23, //  30: sd zero,24(a5)
        'h0207b023, //  34: sd zero,32(a5)
        'h0207b423, //  38: sd zero,40(a5)
        'h0207b823, //  3c: sd zero,48(a5)
        'hf6843783, //  40: ld a5,-152(s0)
        'h00002737, //  44: lui a4,0x2
        'h00073703, //  48: ld a4,0(a4) # 2000 <__muldi3+0x1e0c>
        'h00e7b023, //  4c: sd a4,0(a5)
        'hf6843783, //  50: ld a5,-152(s0)
        'h0087d703, //  54: lhu a4,8(a5)
        'h00176713, //  58: ori a4,a4,1
        'h00e79423, //  5c: sh a4,8(a5)
        'hf6843783, //  60: ld a5,-152(s0)
        'h00400713, //  64: li a4,4
        'h00e7a823, //  68: sw a4,16(a5)
        'hf6843783, //  6c: ld a5,-152(s0)
        'h00100713, //  70: li a4,1
        'h00e7aa23, //  74: sw a4,20(a5)
        'hf6843783, //  78: ld a5,-152(s0)
        'h00200713, //  7c: li a4,2
        'h00e7ac23, //  80: sw a4,24(a5)
        'hf6843783, //  84: ld a5,-152(s0)
        'h00300713, //  88: li a4,3
        'h00e7ae23, //  8c: sw a4,28(a5)
        'hf6843783, //  90: ld a5,-152(s0)
        'h00400713, //  94: li a4,4
        'h02e7a023, //  98: sw a4,32(a5)
        'h00100793, //  9c: li a5,1
        'hfef42623, //  a0: sw a5,-20(s0)
        'h0fc0006f, //  a4: j 1a0 <network_init+0x190>
        'hfec46703, //  a8: lwu a4,-20(s0)
        'h00070793, //  ac: mv a5,a4
        'h00379793, //  b0: slli a5,a5,0x3
        'h40e787b3, //  b4: sub a5,a5,a4
        'h00379793, //  b8: slli a5,a5,0x3
        'h00078713, //  bc: mv a4,a5
        'hf6843783, //  c0: ld a5,-152(s0)
        'h00e787b3, //  c4: add a5,a5,a4
        'h0007b023, //  c8: sd zero,0(a5)
        'h0007b423, //  cc: sd zero,8(a5)
        'h0007b823, //  d0: sd zero,16(a5)
        'h0007bc23, //  d4: sd zero,24(a5)
        'h0207b023, //  d8: sd zero,32(a5)
        'h0207b423, //  dc: sd zero,40(a5)
        'h0207b823, //  e0: sd zero,48(a5)
        'h0087d703, //  e4: lhu a4,8(a5)
        'h00176713, //  e8: ori a4,a4,1
        'h00e79423, //  ec: sh a4,8(a5)
        'hfec42703, //  f0: lw a4,-20(s0)
        'h00e7a623, //  f4: sw a4,12(a5)
        'h00500713, //  f8: li a4,5
        'h00e7a823, //  fc: sw a4,16(a5)
        'hfe042423, // 100: sw zero,-24(s0)
        'h0600006f, // 104: j 164 <network_init+0x154>
        'hf6843783, // 108: ld a5,-152(s0)
        'h0107a783, // 10c: lw a5,16(a5)
        'hfe842703, // 110: lw a4,-24(s0)
        'h00f707bb, // 114: addw a5,a4,a5
        'h0007861b, // 118: sext.w a2,a5
        'hfec46703, // 11c: lwu a4,-20(s0)
        'h00070793, // 120: mv a5,a4
        'h00379793, // 124: slli a5,a5,0x3
        'h40e787b3, // 128: sub a5,a5,a4
        'h00379793, // 12c: slli a5,a5,0x3
        'h00078713, // 130: mv a4,a5
        'hf6843783, // 134: ld a5,-152(s0)
        'h00e786b3, // 138: add a3,a5,a4
        'h0016079b, // 13c: addiw a5,a2,1
        'h0007871b, // 140: sext.w a4,a5
        'hfe846783, // 144: lwu a5,-24(s0)
        'h00478793, // 148: addi a5,a5,4
        'h00279793, // 14c: slli a5,a5,0x2
        'h00f687b3, // 150: add a5,a3,a5
        'h00e7a223, // 154: sw a4,4(a5)
        'hfe842783, // 158: lw a5,-24(s0)
        'h0017879b, // 15c: addiw a5,a5,1
        'hfef42423, // 160: sw a5,-24(s0)
        'hfec46703, // 164: lwu a4,-20(s0)
        'h00070793, // 168: mv a5,a4
        'h00379793, // 16c: slli a5,a5,0x3
        'h40e787b3, // 170: sub a5,a5,a4
        'h00379793, // 174: slli a5,a5,0x3
        'h00078713, // 178: mv a4,a5
        'hf6843783, // 17c: ld a5,-152(s0)
        'h00e787b3, // 180: add a5,a5,a4
        'h0107a703, // 184: lw a4,16(a5)
        'hfe842783, // 188: lw a5,-24(s0)
        'h0007879b, // 18c: sext.w a5,a5
        'hf6e7ece3, // 190: bltu a5,a4,108 <network_init+0xf8>
        'hfec42783, // 194: lw a5,-20(s0)
        'h0017879b, // 198: addiw a5,a5,1
        'hfef42623, // 19c: sw a5,-20(s0)
        'hf6843783, // 1a0: ld a5,-152(s0)
        'h0107a783, // 1a4: lw a5,16(a5)
        'h0017879b, // 1a8: addiw a5,a5,1
        'h0007871b, // 1ac: sext.w a4,a5
        'hfec42783, // 1b0: lw a5,-20(s0)
        'h0007879b, // 1b4: sext.w a5,a5
        'heee7e8e3, // 1b8: bltu a5,a4,a8 <network_init+0x98>
        'h00000013, // 1bc: nop
        'h00000013, // 1c0: nop
        'h09813403, // 1c4: ld s0,152(sp)
        'h0a010113, // 1c8: addi sp,sp,160
        'h00008067, // 1cc: ret
        'hc0010113, // 1d0: addi sp,sp,-1024
        'h3e113c23, // 1d4: sd ra,1016(sp)
        'h3e813823, // 1d8: sd s0,1008(sp)
        'h40010413, // 1dc: addi s0,sp,1024
        'hc0040793, // 1e0: addi a5,s0,-1024
        'h00078513, // 1e4: mv a0,a5
        'he29ff0ef, // 1e8: jal ra,10 <network_init>
        'h00000013, // 1ec: nop
        'hffdff06f, // 1f0: j 1ec <main+0x1c>
        'h00050613, // 1f4: mv a2,a0
        'h00000513, // 1f8: li a0,0
        'h0015f693, // 1fc: andi a3,a1,1
        'h00068463, // 200: beqz a3,208 <__muldi3+0x14>
        'h00c50533, // 204: add a0,a0,a2
        'h0015d593, // 208: srli a1,a1,0x1
        'h00161613, // 20c: slli a2,a2,0x1
        'hfe0596e3, // 210: bnez a1,1fc <__muldi3+0x8>
        'h00008067  // 214: ret
    };
    assign rom [134:255] = '{(256-134){'0}};
    assign q = rom[addr];
endmodule