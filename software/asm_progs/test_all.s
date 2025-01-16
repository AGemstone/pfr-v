_start:
    # Load immediate values
    li x5, 10         # x5 = 10
    nop
    nop
    nop
    li x6, 20         # x6 = 20
    nop
    nop
    nop
    
    # Arithmetic instructions
    add x7, x5, x6    # x7 = x5 + x6 = 30
    nop
    nop
    nop
    sub x8, x6, x5    # x8 = x6 - x5 = 10
    nop
    nop
    nop
    
    # Logical instructions
    and x9, x5, x6    # x9 = x5 & x6 = 0
    nop
    nop
    nop
    or x10, x5, x6    # x10 = x5 | x6 = 30
    nop
    nop
    nop
    xor x11, x5, x6   # x11 = x5 ^ x6 = 30
    nop
    nop
    nop
    
    # Shift instructions
    sll x12, x5, x6   # x12 = x5 << (x6 & 0x1F) = 10 << 20
    nop
    nop
    nop
    srl x13, x6, x5   # x13 = x6 >> (x5 & 0x1F) = 20 >> 10
    nop
    nop
    nop
    sra x14, x6, x5   # x14 = 20 >> 10 (arithmetic shift right)
    nop
    nop
    nop
    
    # Memory instructions
    # la x15, result    # Load address of result into x15 no worries
    li x15, 0
    nop
    nop
    nop
    sw x7, 0(x15)     # Store word x7 into memory at address in x15 (result = 30)
    nop
    nop
    nop
    nop
    lw x16, 0(x15)    # Load word from memory into x16 (x16 = 30)
    nop
    nop
    nop
    
    # Control flow instructions
    beq x7, x16, equal_label   # Branch if x7 == x16 (will branch)
    nop
    nop
    nop
    
    li x17, 1       # This instruction should be skipped if the branch is taken
    nop
    nop
    nop
    
equal_label:
    li x18, 0       # x18 = 0, indicating branch was taken
    nop
    nop
    nop
    
    # Store final result in memory
    # sw x18, 0(x15)
    nop
    nop
    nop

    # Exit the program using ecall
    # li a7, 93       # sys_exit system call number in RISC-V
    # nop
    # nop
    # nop
    # ecall           # Make the system call

# The program would typically not reach here
halt:
    j halt         # Infinite loop to end the program
