.section .init
# Disable the generation of compressed instructions
.option norvc
.type start, @function
.global start
start:
	nop
	# Disable linker relaxation to write to the gp:
	# The linker uses the global_pointer symbol definition to compare the 	 
	# memory addresses and, if within range, it replaces 					  
	# absolute/pc-relative addressing with gp-relative addressing, 		 
	# which makes the code more efficient.									 
	# This process is also called relaxing.								 
	# Source: https://gnu-mcu-eclipse.github.io/arch/riscv/programmer/		 
	.option push
	.option norelax
	la gp, global_pointer
	.option pop
	
	# Reset led status
	sd zero, 0(zero)
	
	# Setup stack
	la sp, stack_top
	mv fp, sp
	
	# Read data from a double ported RO
	# Currently disabled since we load data using single port and a mif file
# 	li t6, 0xfff8
# 	ld t5, 0(t6)
# 	mv s1, gp
	
# rom_read:
# 	addi t6, t6, -16
# 	ld t4, 0(t6)
# 	ld t3, 8(t6)
	
# 	slli t4, t4, 32
# 	add t3, t3, t4
	
# 	sd t3, (s1)
# 	addi s1, s1, 8
	
# 	addi t5, t5, -1
# 	bnez t5, rom_read

	# Enable M mode exceptions
	csrsi mstatus, 8
	la t5, never_ret_except_0
	csrw mtvec, t5
	
	# Jump to main
	jal ra, main
	
	# When we return, turn on led to notify human we're alive
	li t6, 1
	sd t6, 0(zero)
	
	# Notify coprocessor the program has finished
	ebreak

never_ret_done:
	j never_ret_done
never_ret_err:
	j never_ret_err
	# Very basic interrupt handler
never_ret_except_0:
	li t2, 3
	csrr t0, mcause
	csrr t1, mepc
 	# If mcause is breakpoint just skip instruction to previous point
	bne t0, t2, never_ret_except_1
	j never_ret_done
# 	# addi t1, t1, 4
# 	# csrw mepc, t1
# 	# mret
never_ret_except_1:
	sd t0, 8(zero)  # 1
	sd t1, 16(zero) # 2
	sd a1, 24(zero) # 3
	sd a2, 32(zero) # 4
	sd a3, 40(zero) # 5
	sd a4, 48(zero) # 6
	sd a5, 56(zero) # 7
	sd sp, 64(zero) # 8
	sd fp, 72(zero) # 9
	li a0, -1
	ebreak
	j never_ret_err
.end
