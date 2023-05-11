	.file	"compile_helpers.c"
	.option nopic
	.attribute arch, "rv64i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	memcpy
	.type	memcpy, @function
memcpy:
	li	a5,0
.L2:
	bne	a5,a2,.L3
	ret
.L3:
	add	a4,a1,a5
	lbu	a3,0(a4)
	add	a4,a0,a5
	addi	a5,a5,1
	sb	a3,0(a4)
	j	.L2
	.size	memcpy, .-memcpy
	.ident	"GCC: (g1ea978e3066) 12.1.0"
	.section	.note.GNU-stack,"",@progbits
