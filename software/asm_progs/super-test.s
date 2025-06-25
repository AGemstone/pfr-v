# RISC-V Pipeline Test Program
# Tests all major instruction types and pipeline functionality

.section .text
.global _start

_start:
    # Test 1: Register-Register Operations (R-type)
    li x1, 0x1234ABCD       # Load test value
    li x2, 0x5678DCBA       # Load test value
    
    add x3, x1, x2          # Test ADD
    sub x4, x1, x2          # Test SUB
    and x5, x1, x2          # Test AND
    or x6, x1, x2           # Test OR
    xor x7, x1, x2          # Test XOR
    slt x8, x1, x2          # Test SLT
    sltu x9, x1, x2         # Test SLTU
    sll x10, x1, x2         # Test SLL
    srl x11, x1, x2         # Test SRL
    sra x12, x1, x2         # Test SRA
    
    # Test 2: Immediate Operations (I-type)
    addi x13, x1, 0x7FF    # Test ADDI
    addi x14, x1, -0x800    # Test ADDI negative
    andi x15, x1, 0x7FF    # Test ANDI
    ori x16, x1, 0x7FF      # Test ORI
    xori x17, x1, 0x7FF     # Test XORI
    slti x18, x1, 0x7FF     # Test SLTI
    sltiu x19, x1, 0x7FF    # Test SLTIU
    slli x20, x1, 5         # Test SLLI
    srli x21, x1, 5         # Test SRLI
    srai x22, x1, 5         # Test SRAI
    
    # Test 3: Load/Store Operations
    la x23, test_data       # Load address
    lw x24, 0(x23)          # Test LW
    sw x1, 4(x23)           # Test SW
    lh x25, 0(x23)          # Test LH
    lhu x26, 0(x23)         # Test LHU
    sh x1, 8(x23)           # Test SH
    lb x27, 0(x23)          # Test LB
    lbu x28, 0(x23)         # Test LBU
    sb x1, 12(x23)          # Test SB
    
    # Test 4: Branch Operations
    li x29, 10
    li x30, 20
    
branch_test:
    beq x29, x30, branch_fail
    bne x29, x30, branch_ok1
    
branch_fail:
    j test_failed
    
branch_ok1:
    blt x29, x30, branch_ok2
    j test_failed
    
branch_ok2:
    bge x30, x29, branch_ok3
    j test_failed
    
branch_ok3:
    bltu x29, x30, branch_ok4
    j test_failed
    
branch_ok4:
    bgeu x30, x29, branch_ok5
    j test_failed
    
branch_ok5:
    li x31, 5
loop_test:
    addi x31, x31, -1
    bne x31, x0, loop_test
    
    # Test 5: Jump Operations
    jal x1, jal_test
    j jal_fail
    
jal_test:
    la x2, jalr_target
    jal x3, jalr_target
    j jalr_fail
    
jalr_target:
    # Pipeline Hazard Tests
    li x4, 10
    add x5, x4, x4
    add x6, x5, x4
    
    li x7, 5
    li x8, 10
    add x7, x8, x8
    
    li x9, 15
    li x9, 20
    
    li x10, 1
    add x11, x10, x10
    add x12, x11, x10
    
    la x13, test_data
    lw x14, 0(x13)
    add x15, x14, x14
    
    j test_passed
    
jal_fail:
jalr_fail:
test_failed:
    li x31, 0xDEADBEEF
    j end_test
    
test_passed:
    li x31, 0xCAFEBABE
    
end_test:
    j end_test

.section .data
test_data:
    .word 0x89ABCDEF
    .word 0
    .word 0
    .word 0
