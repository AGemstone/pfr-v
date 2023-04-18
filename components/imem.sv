module imem #(parameter N = 32)(
    input logic[7:0] addr,
    output logic[N-1:0] q
);
    logic [N - 1:0] rom [0 : 255];
    assign rom[0:207] = '{
        'h00003023, //   0: sd zero,0(zero) # 0 <start>
        'h00000f93, //   4: li t6,0
        'h40000113, //   8: li sp,1024
        'h1f00006f, //   c: j 1fc <kmain>
        'hfb010113, //  10: addi sp,sp,-80
        'h04113423, //  14: sd ra,72(sp)
        'h04813023, //  18: sd s0,64(sp)
        'h02913c23, //  1c: sd s1,56(sp)
        'h05010413, //  20: addi s0,sp,80
        'hfca43423, //  24: sd a0,-56(s0)
        'hfcb43023, //  28: sd a1,-64(s0)
        'hfac43c23, //  2c: sd a2,-72(s0)
        'hfc042e23, //  30: sw zero,-36(s0)
        'h19c0006f, //  34: j 1d0 <matrix_mul+0x1c0>
        'hfc042c23, //  38: sw zero,-40(s0)
        'h1780006f, //  3c: j 1b4 <matrix_mul+0x1a4>
        'hfdc42783, //  40: lw a5,-36(s0)
        'h00078713, //  44: mv a4,a5
        'h00070793, //  48: mv a5,a4
        'h0017979b, //  4c: slliw a5,a5,0x1
        'h00e787bb, //  50: addw a5,a5,a4
        'h0007879b, //  54: sext.w a5,a5
        'hfd842703, //  58: lw a4,-40(s0)
        'h00f707bb, //  5c: addw a5,a4,a5
        'h0007879b, //  60: sext.w a5,a5
        'h02079793, //  64: slli a5,a5,0x20
        'h0207d793, //  68: srli a5,a5,0x20
        'h00379793, //  6c: slli a5,a5,0x3
        'hfb843703, //  70: ld a4,-72(s0)
        'h00f707b3, //  74: add a5,a4,a5
        'h0007b023, //  78: sd zero,0(a5)
        'hfc042a23, //  7c: sw zero,-44(s0)
        'h1180006f, //  80: j 198 <matrix_mul+0x188>
        'hfdc42783, //  84: lw a5,-36(s0)
        'h00078713, //  88: mv a4,a5
        'h00070793, //  8c: mv a5,a4
        'h0017979b, //  90: slliw a5,a5,0x1
        'h00e787bb, //  94: addw a5,a5,a4
        'h0007879b, //  98: sext.w a5,a5
        'hfd842703, //  9c: lw a4,-40(s0)
        'h00f707bb, //  a0: addw a5,a4,a5
        'h0007879b, //  a4: sext.w a5,a5
        'h02079793, //  a8: slli a5,a5,0x20
        'h0207d793, //  ac: srli a5,a5,0x20
        'h00379793, //  b0: slli a5,a5,0x3
        'hfb843703, //  b4: ld a4,-72(s0)
        'h00f707b3, //  b8: add a5,a4,a5
        'h0007b483, //  bc: ld s1,0(a5)
        'hfdc42783, //  c0: lw a5,-36(s0)
        'h00078713, //  c4: mv a4,a5
        'h00070793, //  c8: mv a5,a4
        'h0017979b, //  cc: slliw a5,a5,0x1
        'h00e787bb, //  d0: addw a5,a5,a4
        'h0007879b, //  d4: sext.w a5,a5
        'hfd442703, //  d8: lw a4,-44(s0)
        'h00f707bb, //  dc: addw a5,a4,a5
        'h0007879b, //  e0: sext.w a5,a5
        'h02079793, //  e4: slli a5,a5,0x20
        'h0207d793, //  e8: srli a5,a5,0x20
        'h00379793, //  ec: slli a5,a5,0x3
        'hfc843703, //  f0: ld a4,-56(s0)
        'h00f707b3, //  f4: add a5,a4,a5
        'h0007b683, //  f8: ld a3,0(a5)
        'hfd442783, //  fc: lw a5,-44(s0)
        'h00078713, // 100: mv a4,a5
        'h00070793, // 104: mv a5,a4
        'h0017979b, // 108: slliw a5,a5,0x1
        'h00e787bb, // 10c: addw a5,a5,a4
        'h0007879b, // 110: sext.w a5,a5
        'hfd842703, // 114: lw a4,-40(s0)
        'h00f707bb, // 118: addw a5,a4,a5
        'h0007879b, // 11c: sext.w a5,a5
        'h02079793, // 120: slli a5,a5,0x20
        'h0207d793, // 124: srli a5,a5,0x20
        'h00379793, // 128: slli a5,a5,0x3
        'hfc043703, // 12c: ld a4,-64(s0)
        'h00f707b3, // 130: add a5,a4,a5
        'h0007b783, // 134: ld a5,0(a5)
        'h00078593, // 138: mv a1,a5
        'h00068513, // 13c: mv a0,a3
        'h1dc000ef, // 140: jal ra,31c <__muldi3>
        'h00050793, // 144: mv a5,a0
        'h00078693, // 148: mv a3,a5
        'hfdc42783, // 14c: lw a5,-36(s0)
        'h00078713, // 150: mv a4,a5
        'h00070793, // 154: mv a5,a4
        'h0017979b, // 158: slliw a5,a5,0x1
        'h00e787bb, // 15c: addw a5,a5,a4
        'h0007879b, // 160: sext.w a5,a5
        'hfd842703, // 164: lw a4,-40(s0)
        'h00f707bb, // 168: addw a5,a4,a5
        'h0007879b, // 16c: sext.w a5,a5
        'h02079793, // 170: slli a5,a5,0x20
        'h0207d793, // 174: srli a5,a5,0x20
        'h00379793, // 178: slli a5,a5,0x3
        'hfb843703, // 17c: ld a4,-72(s0)
        'h00f707b3, // 180: add a5,a4,a5
        'h00d48733, // 184: add a4,s1,a3
        'h00e7b023, // 188: sd a4,0(a5)
        'hfd442783, // 18c: lw a5,-44(s0)
        'h0017879b, // 190: addiw a5,a5,1
        'hfcf42a23, // 194: sw a5,-44(s0)
        'hfd442783, // 198: lw a5,-44(s0)
        'h0007871b, // 19c: sext.w a4,a5
        'h00200793, // 1a0: li a5,2
        'heee7f0e3, // 1a4: bgeu a5,a4,84 <matrix_mul+0x74>
        'hfd842783, // 1a8: lw a5,-40(s0)
        'h0017879b, // 1ac: addiw a5,a5,1
        'hfcf42c23, // 1b0: sw a5,-40(s0)
        'hfd842783, // 1b4: lw a5,-40(s0)
        'h0007871b, // 1b8: sext.w a4,a5
        'h00200793, // 1bc: li a5,2
        'he8e7f0e3, // 1c0: bgeu a5,a4,40 <matrix_mul+0x30>
        'hfdc42783, // 1c4: lw a5,-36(s0)
        'h0017879b, // 1c8: addiw a5,a5,1
        'hfcf42e23, // 1cc: sw a5,-36(s0)
        'hfdc42783, // 1d0: lw a5,-36(s0)
        'h0007871b, // 1d4: sext.w a4,a5
        'h00200793, // 1d8: li a5,2
        'he4e7fee3, // 1dc: bgeu a5,a4,38 <matrix_mul+0x28>
        'h00000013, // 1e0: nop
        'h00000013, // 1e4: nop
        'h04813083, // 1e8: ld ra,72(sp)
        'h04013403, // 1ec: ld s0,64(sp)
        'h03813483, // 1f0: ld s1,56(sp)
        'h05010113, // 1f4: addi sp,sp,80
        'h00008067, // 1f8: ret
        'hef010113, // 1fc: addi sp,sp,-272
        'h10113423, // 200: sd ra,264(sp)
        'h10813023, // 204: sd s0,256(sp)
        'h11010413, // 208: addi s0,sp,272
        'hfe042423, // 20c: sw zero,-24(s0)
        'hfe042223, // 210: sw zero,-28(s0)
        'h00000013, // 214: nop
        'h000027b7, // 218: lui a5,0x2
        'h00078793, // 21c: mv a5,a5
        'h0007b303, // 220: ld t1,0(a5) # 2000 <__muldi3+0x1ce4>
        'h0087b883, // 224: ld a7,8(a5)
        'h0107b803, // 228: ld a6,16(a5)
        'h0187b503, // 22c: ld a0,24(a5)
        'h0207b583, // 230: ld a1,32(a5)
        'h0287b603, // 234: ld a2,40(a5)
        'h0307b683, // 238: ld a3,48(a5)
        'h0387b703, // 23c: ld a4,56(a5)
        'h0407b783, // 240: ld a5,64(a5)
        'hf8643c23, // 244: sd t1,-104(s0)
        'hfb143023, // 248: sd a7,-96(s0)
        'hfb043423, // 24c: sd a6,-88(s0)
        'hfaa43823, // 250: sd a0,-80(s0)
        'hfab43c23, // 254: sd a1,-72(s0)
        'hfcc43023, // 258: sd a2,-64(s0)
        'hfcd43423, // 25c: sd a3,-56(s0)
        'hfce43823, // 260: sd a4,-48(s0)
        'hfcf43c23, // 264: sd a5,-40(s0)
        'h000027b7, // 268: lui a5,0x2
        'h04878793, // 26c: addi a5,a5,72 # 2048 <__muldi3+0x1d2c>
        'h0007b303, // 270: ld t1,0(a5)
        'h0087b883, // 274: ld a7,8(a5)
        'h0107b803, // 278: ld a6,16(a5)
        'h0187b503, // 27c: ld a0,24(a5)
        'h0207b583, // 280: ld a1,32(a5)
        'h0287b603, // 284: ld a2,40(a5)
        'h0307b683, // 288: ld a3,48(a5)
        'h0387b703, // 28c: ld a4,56(a5)
        'h0407b783, // 290: ld a5,64(a5)
        'hf4643823, // 294: sd t1,-176(s0)
        'hf5143c23, // 298: sd a7,-168(s0)
        'hf7043023, // 29c: sd a6,-160(s0)
        'hf6a43423, // 2a0: sd a0,-152(s0)
        'hf6b43823, // 2a4: sd a1,-144(s0)
        'hf6c43c23, // 2a8: sd a2,-136(s0)
        'hf8d43023, // 2ac: sd a3,-128(s0)
        'hf8e43423, // 2b0: sd a4,-120(s0)
        'hf8f43823, // 2b4: sd a5,-112(s0)
        'hfe042623, // 2b8: sw zero,-20(s0)
        'h0240006f, // 2bc: j 2e0 <kmain+0xe4>
        'hfec46783, // 2c0: lwu a5,-20(s0)
        'h00379793, // 2c4: slli a5,a5,0x3
        'hff078793, // 2c8: addi a5,a5,-16
        'h008787b3, // 2cc: add a5,a5,s0
        'hf007b023, // 2d0: sd zero,-256(a5)
        'hfec42783, // 2d4: lw a5,-20(s0)
        'h0017879b, // 2d8: addiw a5,a5,1
        'hfef42623, // 2dc: sw a5,-20(s0)
        'hfec42783, // 2e0: lw a5,-20(s0)
        'h0007871b, // 2e4: sext.w a4,a5
        'h00b00793, // 2e8: li a5,11
        'hfce7fae3, // 2ec: bgeu a5,a4,2c0 <kmain+0xc4>
        'hef040693, // 2f0: addi a3,s0,-272
        'hf5040713, // 2f4: addi a4,s0,-176
        'hf9840793, // 2f8: addi a5,s0,-104
        'h00068613, // 2fc: mv a2,a3
        'h00070593, // 300: mv a1,a4
        'h00078513, // 304: mv a0,a5
        'hd09ff0ef, // 308: jal ra,10 <matrix_mul>
        'h00100f93, // 30c: li t6,1
        'h01f03023, // 310: sd t6,0(zero) # 0 <start>
        'h00000013, // 314: nop
        'hffdff06f, // 318: j 314 <kmain+0x118>
        'h00050613, // 31c: mv a2,a0
        'h00000513, // 320: li a0,0
        'h0015f693, // 324: andi a3,a1,1
        'h00068463, // 328: beqz a3,330 <__muldi3+0x14>
        'h00c50533, // 32c: add a0,a0,a2
        'h0015d593, // 330: srli a1,a1,0x1
        'h00161613, // 334: slli a2,a2,0x1
        'hfe0596e3, // 338: bnez a1,324 <__muldi3+0x8>
        'h00008067  // 33c: ret
    };
    assign rom [208:255] = '{(256-208){'0}};
    assign q = rom[addr];
endmodule