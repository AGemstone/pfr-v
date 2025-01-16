    .section .data
    .section .text
    .globl _start

_start:
    # Initialize some test values
    li x1, 1              # Load immediate 1 into x1
    li x2, -1             # Load immediate -1 into x2
    li x3, 16             # Load immediate 16 into x3
    li x4, 32          # Load immediate 65535 into x4

    # ADD - Testing Addition
    add x5, x1, x2         # x5 = x1 + x2
    
    # SUB - Testing Subtraction
    sub x6, x3, x1         # x6 = x3 - x1

    # AND - Testing Logical AND
    and x7, x4, x2         # x7 = x4 & x2

    # OR - Testing Logical OR
    or x8, x4, x1          # x8 = x4 | x1

    # XOR - Testing Logical XOR
    xor x9, x3, x4         # x9 = x3 ^ x4

    # SLL - Testing Shift Left Logical
    sll x10, x3, x1        # x10 = x3 << x1

    # SRL - Testing Shift Right Logical
    srl x11, x3, x1        # x11 = x3 >> x1

    # SRA - Testing Shift Right Arithmetic
    sra x12, x2, x1        # x12 = x2 >> x1

    # SLT - Testing Set Less Than
    slt x13, x1, x3        # x13 = (x1 < x3) ? 1 : 0

    # SLTU - Testing Set Less Than Unsigned
    sltu x14, x2, x3       # x14 = (x2 < x3) ? 1 : 0

    # LUI - Testing Load Upper Immediate
    lui x15, 43981         # x15 = 43981 << 16

    # AUIPC - Testing Add Upper Immediate to PC
    auipc x16, 4660        # x16 = PC + 4660 << 16

    # BEQ - Testing Branch if Equal
    beq x1, x1, skip       # Expected: Branch taken to 'skip'

    li x17, 0              # This instruction will be skipped
    
skip:
    li x17, 305419896       # Expected: x17 = 305419896 (0x12345678)

    # JAL - Testing Jump and Link
    jal x18, next          # Expected: Jump to 'next', x18 will hold return address

    li x19, 0              # This instruction will be skipped
    
next:
    li x19, 2271560481      # Expected: x19 = 2271560481 (0x87654321)

    # JALR - Testing Jump and Link Register
    # jalr x20, x1, 8        # Expected: Jump to (x1 + 8), x20 will hold return address

    li x21, 3735928559      # This instruction will be skipped

loop:   beq zero, zero, loop
