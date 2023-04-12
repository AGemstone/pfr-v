.file	"csum.c"
.option nopic
.attribute arch, "rv64i2p0_a2p0"
.attribute unaligned_access, 0
.attribute stack_align, 16
.text
.Ltext0:
.cfi_sections	.debug_frame
.file 0 "/mnt/hdd1/dev/risc/riscv/passiflorisc-v/software/c_progs" "csum.c"
.align	2
.globl	sum
.type	sum, @function
sum:
.LFB0:
.file 1 "csum.c"
.loc 1 4 46
.cfi_startproc
addi	sp,sp,-48
.cfi_def_cfa_offset 48
sd	s0,40(sp)
nop
.cfi_offset 8, -8
addi	s0,sp,48
.cfi_def_cfa 8, 0
sd	a0,-40(s0)
nop
.loc 1 5 22
sd	zero,-24(s0)
nop
.loc 1 6 22
li	a5,1
sd	a5,-32(s0)
nop
.loc 1 7 9
j	.L2
.L3:
.loc 1 8 12
ld	a4,-24(s0)
ld	a4,-24(s0)
ld	a5,-32(s0)
ld	a5,-32(s0)
add	a5,a4,a5
sd	a5,-24(s0)
nop
.loc 1 9 7
ld	a5,-32(s0)
ld	a5,-32(s0)
addi	a5,a5,1
sd	a5,-32(s0)
nop
.L2:
.loc 1 7 12
ld	a4,-32(s0)
ld	a4,-32(s0)
ld	a5,-40(s0)
ld	a5,-40(s0)
bltu	a4,a5,.L3
.loc 1 11 10
ld	a5,-24(s0)
ld	a5,-24(s0)
.loc 1 12 1
mv	a0,a5
ld	s0,40(sp)
ld	s0,40(sp)
.cfi_restore 8
.cfi_def_cfa 2, 48
addi	sp,sp,48
.cfi_def_cfa_offset 0
jr	ra
.cfi_endproc
.LFE0:
.size	sum, .-sum
.align	2
.globl	kmain
.type	kmain, @function
kmain:
.LFB1:
.loc 1 14 17
.cfi_startproc
addi	sp,sp,-32
.cfi_def_cfa_offset 32
sd	ra,24(sp)
nop
sd	s0,16(sp)
nop
.cfi_offset 1, -8
.cfi_offset 8, -16
addi	s0,sp,32
.cfi_def_cfa 8, 0
.loc 1 15 33
li	a0,5
call	sum
sd	a0,-24(s0)
nop
.loc 1 16 3
#APP
# 16 "csum.c" 1
li t6, 1;                sd t6, 0(zero);
# 0 "" 2
#NO_APP
.L6:
.loc 1 19 3 discriminator 1
nop
j	.L6
.cfi_endproc
.LFE1:
.size	kmain, .-kmain
.Letext0:
.section	.debug_info,"",@progbits
.Ldebug_info0:
.4byte	0xaf
.2byte	0x5
.byte	0x1
.byte	0x8
.4byte	.Ldebug_abbrev0
.byte	0x2
.4byte	.LASF5
.byte	0x1d
.4byte	.LASF0
.4byte	.LASF1
.8byte	.Ltext0
.8byte	.Letext0-.Ltext0
.4byte	.Ldebug_line0
.byte	0x3
.4byte	.LASF6
.byte	0x1
.byte	0xe
.byte	0x5
.4byte	0x5e
.8byte	.LFB1
.8byte	.LFE1-.LFB1
.byte	0x1
.byte	0x9c
.4byte	0x5e
.byte	0x1
.4byte	.LASF3
.byte	0xf
.4byte	0x65
.byte	0x2
.byte	0x91
.byte	0x68
.byte	0
.byte	0x4
.byte	0x4
.byte	0x5
.string	"int"
.byte	0x5
.byte	0x8
.byte	0x7
.4byte	.LASF2
.byte	0x6
.string	"sum"
.byte	0x1
.byte	0x4
.byte	0x14
.4byte	0x65
.8byte	.LFB0
.8byte	.LFE0-.LFB0
.byte	0x1
.byte	0x9c
.byte	0x7
.string	"n"
.byte	0x1
.byte	0x4
.byte	0x2b
.4byte	0x65
.byte	0x2
.byte	0x91
.byte	0x58
.byte	0x1
.4byte	.LASF4
.byte	0x5
.4byte	0x65
.byte	0x2
.byte	0x91
.byte	0x68
.byte	0x8
.string	"i"
.byte	0x1
.byte	0x6
.byte	0x16
.4byte	0x65
.byte	0x2
.byte	0x91
.byte	0x60
.byte	0
.byte	0
.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
.byte	0x1
.byte	0x34
.byte	0
.byte	0x3
.byte	0xe
.byte	0x3a
.byte	0x21
.byte	0x1
.byte	0x3b
.byte	0xb
.byte	0x39
.byte	0x21
.byte	0x16
.byte	0x49
.byte	0x13
.byte	0x2
.byte	0x18
.byte	0
.byte	0
.byte	0x2
.byte	0x11
.byte	0x1
.byte	0x25
.byte	0xe
.byte	0x13
.byte	0xb
.byte	0x3
.byte	0x1f
.byte	0x1b
.byte	0x1f
.byte	0x11
.byte	0x1
.byte	0x12
.byte	0x7
.byte	0x10
.byte	0x17
.byte	0
.byte	0
.byte	0x3
.byte	0x2e
.byte	0x1
.byte	0x3f
.byte	0x19
.byte	0x3
.byte	0xe
.byte	0x3a
.byte	0xb
.byte	0x3b
.byte	0xb
.byte	0x39
.byte	0xb
.byte	0x27
.byte	0x19
.byte	0x49
.byte	0x13
.byte	0x11
.byte	0x1
.byte	0x12
.byte	0x7
.byte	0x40
.byte	0x18
.byte	0x7c
.byte	0x19
.byte	0x1
.byte	0x13
.byte	0
.byte	0
.byte	0x4
.byte	0x24
.byte	0
.byte	0xb
.byte	0xb
.byte	0x3e
.byte	0xb
.byte	0x3
.byte	0x8
.byte	0
.byte	0
.byte	0x5
.byte	0x24
.byte	0
.byte	0xb
.byte	0xb
.byte	0x3e
.byte	0xb
.byte	0x3
.byte	0xe
.byte	0
.byte	0
.byte	0x6
.byte	0x2e
.byte	0x1
.byte	0x3f
.byte	0x19
.byte	0x3
.byte	0x8
.byte	0x3a
.byte	0xb
.byte	0x3b
.byte	0xb
.byte	0x39
.byte	0xb
.byte	0x27
.byte	0x19
.byte	0x49
.byte	0x13
.byte	0x11
.byte	0x1
.byte	0x12
.byte	0x7
.byte	0x40
.byte	0x18
.byte	0x7a
.byte	0x19
.byte	0
.byte	0
.byte	0x7
.byte	0x5
.byte	0
.byte	0x3
.byte	0x8
.byte	0x3a
.byte	0xb
.byte	0x3b
.byte	0xb
.byte	0x39
.byte	0xb
.byte	0x49
.byte	0x13
.byte	0x2
.byte	0x18
.byte	0
.byte	0
.byte	0x8
.byte	0x34
.byte	0
.byte	0x3
.byte	0x8
.byte	0x3a
.byte	0xb
.byte	0x3b
.byte	0xb
.byte	0x39
.byte	0xb
.byte	0x49
.byte	0x13
.byte	0x2
.byte	0x18
.byte	0
.byte	0
.byte	0
.section	.debug_aranges,"",@progbits
.4byte	0x2c
.2byte	0x2
.4byte	.Ldebug_info0
.byte	0x8
.byte	0
.2byte	0
.2byte	0
.8byte	.Ltext0
.8byte	.Letext0-.Ltext0
.8byte	0
.8byte	0
.section	.debug_line,"",@progbits
.Ldebug_line0:
.section	.debug_str,"MS",@progbits,1
.LASF3:
.string	"result_1"
.LASF6:
.string	"kmain"
.LASF4:
.string	"result"
.LASF2:
.string	"long long unsigned int"
.LASF5:
.string	"GNU C17 12.1.0 -mcmodel=medany -mtune=rocket -mabi=lp64 -misa-spec=2.2 -march=rv64ia -g -ffreestanding"
.section	.debug_line_str,"MS",@progbits,1
.LASF0:
.string	"csum.c"
.LASF1:
.string	"/mnt/hdd1/dev/risc/riscv/passiflorisc-v/software/c_progs"
.ident	"GCC: (g1ea978e3066) 12.1.0"
.section	.note.GNU-stack,"",@progbits
