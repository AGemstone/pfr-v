# Memory instruction and hazard test (no .data section)
# Assumes all memory starts at 0
# Tests load/store RAW, WAR, and WAW hazards

.text
.globl _start

_start:
    # Initialize memory with stores first (since memory starts at 0)
    li x1, 0x10000000        # Base address 1
    li x2, 0x20000000        # Base address 2
    
    # Store test values to memory
    li x3, 0x11111111
    sw x3, 0(x1)             # Mem[0x10000000] = 0x11111111
    li x4, 0x22222222
    sw x4, 4(x1)             # Mem[0x10000004] = 0x22222222
    li x5, 0x33333333
    sw x5, 8(x1)             # Mem[0x10000008] = 0x33333333
    li x6, 0x44444444
    sw x6, 12(x1)            # Mem[0x1000000C] = 0x44444444
    li x7, 0x55555555
    sw x7, 16(x1)            # Mem[0x10000010] = 0x55555555
    li x8, 0x12345678
    sw x8, 20(x1)            # Mem[0x10000014] = 0x12345678

    # Test 1: Simple load after store (no hazard)
    lw x9, 0(x1)             # x9 = 0x11111111
    add x10, x9, x0          # x10 = 0x11111111 (forwarding test)

    # Test 2: Load-use hazard (RAW)
    lw x11, 4(x1)            # x11 = 0x22222222
    add x12, x11, x0         # Requires forwarding from load

    # Test 3: Store after load (WAR)
    lw x13, 8(x1)            # x13 = 0x33333333
    sw x13, 0(x2)            # Store x13
    addi x13, x13, 1         # Modify x13 after use

    # Test 4: Load after store to same reg (WAW)
    sw x9, 4(x2)             # Store x9
    lw x9, 12(x1)            # x9 = 0x44444444 (overwrite)

    # Test 5: Memory chain
    lw x14, 20(x1)           # x14 = 0x12345678
    addi x14, x14, 1         # x14 = 0x12345679
    sw x14, 8(x2)            # Store modified value
    lw x15, 8(x2)            # Load back
    add x16, x15, x14        # x16 = 0x2468ACF2

    # Test 6: Byte/halfword operations
    lb x17, 20(x1)           # x17 = 0x00000078 (sign-extended byte)
    lbu x18, 20(x1)          # x18 = 0x00000078 (zero-extended byte)
    lh x19, 20(x1)           # x19 = 0x00005678 (sign-extended halfword)
    lhu x20, 20(x1)          # x20 = 0x00005678 (zero-extended halfword)
    sb x17, 12(x2)           # Store byte
    sh x19, 14(x2)           # Store halfword

    # End of tests
    li a7, 93                # Exit syscall
    li a0, 0                 # Exit status
done:
    j done  
