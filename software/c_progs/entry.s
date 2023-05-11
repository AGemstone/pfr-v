.section .init
/* Disable the generation of compressed instructions */
.option norvc
.type start, @function
.global start
start:
	nop
	/* Disable linker relaxation to write to the gp: */
	/* The linker uses the global_pointer symbol definition to compare the 	  */
	/* memory addresses and, if within range, it replaces 					  */ 
	/* absolute/pc-relative addressing with gp-relative addressing, 		  */
	/* which makes the code more efficient.									  */
	/* This process is also called relaxing.								  */
	/* Source: https://gnu-mcu-eclipse.github.io/arch/riscv/programmer/		  */
	.option push
	.option norelax
	la gp, global_pointer
	.option pop
	
	/* Reset led status */
	sd zero, 0(zero)
	
	/* Setup stack */
	la sp, stack_top
	mv fp, sp
	
	/* Read data from ROM */
	/* Currently disabled since we load data using a mif file */
	
	/*
	li t6, 0xfff8
	ld t5, 0(t6)
	mv s1, gp
	
rom_read:
	addi t6, t6, -16
	ld t4, 0(t6)
	ld t3, 8(t6)
	
	slli t4, t4, 32
	add t3, t3, t4
	
	sd t3, (s1)
	addi s1, s1, 8
	
	addi t5, t5, -1
	bnez t5, rom_read
	*/

	/* Enable M mode exceptions */
	csrsi mstatus, 8
	la t5, never_ret
	csrw mtvec, t5
	
	/* Jump to main */
	jal ra, main
	
	/* When we return, turn on led to notify human we're alive */
	li t6, 1
	sd t6, 0(zero)
	
	/* Notify coprocessor the program has finished */
	ebreak

never_ret:
	j never_ret
.end
