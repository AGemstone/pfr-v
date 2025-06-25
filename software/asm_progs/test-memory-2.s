# Simple RISC-V load/store test program
# Initial values:
#   x1 = 0x1000 (data memory base address)
#   x2 = 0x12345678
#   x3 = 0xAABBCCDD

# Store word (sw) and byte (sb) tests
_start:
    li x1, 0x1000           # Load data memory base address (0x1000)
    li x2, 0x12345678       # Test pattern 1
    li x3, 0xAABBCCDD       # Test pattern 2
    
    sw x2, 0(x1)           # Store word at 0x1000
    sb x3, 4(x1)           # Store LSB of x3 (0xDD) at 0x1004
    sh x2, 6(x1)           # Store halfword (lower 16 bits of x2) at 0x1006
    
    # Load tests
    lw x4, 0(x1)           # Load word from 0x1000 (should get 0x12345678)
    lb x5, 4(x1)           # Load byte from 0x1004 (should get 0xFFFFFFDD)
    lbu x6, 4(x1)          # Load unsigned byte from 0x1004 (should get 0x000000DD)
    lh x7, 6(x1)           # Load halfword from 0x1006 (should get 0x00005678)
    lhu x8, 6(x1)          # Load unsigned halfword from 0x1006 (should get 0x00005678)
    
    # End test
loop: j loop                 # Stop execution (for simulation)
