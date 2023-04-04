.section .init
.option norvc
.type start, @function
.global start
start:
	.cfi_startproc
.option push
.option norelax
	/* Currently not in use */
	/* la gp, global_pointer */
.option pop
	sd zero, 0(zero)
	/*t6 is finish flag*/
	mv t6, zero
	/* Setup stack */
	/* la sp, stack_top */
	/* Fixed value due to lack of memory map / constraints*/
	li sp, 1024
	/* Jump to kernel! */
	tail kmain
	.cfi_endproc
.end
