	.file	"ctest.c"
	.option pic
	.attribute arch, "rv64i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	__muldi3
	.align	2
	.globl	mul
	.type	mul, @function
mul:
	addi	sp,sp,-16
	sd	ra,8(sp)
	call	__muldi3@plt
	ld	ra,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	mul, .-mul
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	li	a0,0
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
