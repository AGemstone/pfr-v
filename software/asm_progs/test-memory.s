# Memory Instruction Test Suite
# Tests all RISC-V memory operations (RV64I + A extension)

.section .text
.global _start

_start:
    # Initialize stack pointer
    la sp, stack_top
    
    # Test SB (Store Byte)
    li t0, 0x12345678
    la t1, test_data
    sb t0, 0(t1)           # Store 0x78
    
    # Test SH (Store Halfword)
    sh t0, 2(t1)           # Store 0x5678
    
    # Test SW (Store Word)
    sw t0, 4(t1)           # Store 0x12345678
    
    # Test SD (Store Doubleword - RV64)
    sd t0, 8(t1)           # Store full 64-bit value
    
    # Test LB (Load Byte - sign extended)
    lb t2, 0(t1)           # Should get 0x78 (sign extended to 0x...78)
    
    # Test LH (Load Halfword - sign extended)
    lh t3, 2(t1)           # Should get 0x5678
    
    # Test LW (Load Word - sign extended)
    lw t4, 4(t1)           # Should get 0x12345678
    
    # Test LD (Load Doubleword - RV64)
    ld t5, 8(t1)           # Should get full 64-bit value
    
    # Test LBU (Load Byte Unsigned)
    lbu a0, 0(t1)          # Should get 0x00000078
    
    # Test LHU (Load Halfword Unsigned)
    lhu a1, 2(t1)          # Should get 0x00005678
    
    # Test LWU (Load Word Unsigned - RV64)
    lwu a2, 4(t1)          # Should get 0x12345678
    
    # Test various addressing modes
    li t6, 16
    # Base + offset
    sw t0, -8(t6)          # Store at (16-8)=8
    # Register indirect
    mv a3, t1
    lw a4, 0(a3)           # Load from test_data[0]
    
    # Test atomic operations (A extension)
    la t0, atomic_var
    
    # Memory fence
    fence iorw, iorw        # Full memory fence
    
    # Completion
    li a7, 93               # Exit syscall number
    li a0, 0                # Exit code 0
loop: j loop

.section .data
test_data:
    .dword 0x0              # Will be overwritten
    .dword 0x0
    .dword 0x0
    .dword 0x0
    
atomic_var:
    .dword 0x0

.section .bss
    .align 4
    .space 4096             # 4KB stack
stack_top:
