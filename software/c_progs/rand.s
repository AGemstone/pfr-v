	.file	"rand.c"
	.option nopic
	.attribute arch, "rv64i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	rand_init
	.type	rand_init, @function
rand_init:
	lui	a5,%hi(state)
	sd	a0,%lo(state)(a5)
	ret
	.size	rand_init, .-rand_init
	.align	2
	.globl	rand
	.type	rand, @function
rand:
	lui	a3,%hi(state)
	ld	a5,%lo(state)(a3)
	slli	a4,a5,13
	xor	a4,a4,a5
	srli	a5,a4,7
	xor	a5,a5,a4
	slli	a0,a5,17
	xor	a0,a0,a5
	sd	a0,%lo(state)(a3)
	ret
	.size	rand, .-rand
	.section	.sbss,"aw",@nobits
	.align	3
	.type	state, @object
	.size	state, 8
state:
	.zero	8
	.ident	"GCC: (g1ea978e3066) 12.1.0"
	.section	.note.GNU-stack,"",@progbits
