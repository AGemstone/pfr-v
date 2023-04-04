start:
    jal main
loop:
    beqz zero, loop

mul:
    addi	sp,sp,-32
    sd	ra,24(sp)
    sd	s0,16(sp)
    addi	s0,sp,32
    sd	a0,-24(s0)
    sd	a1,-32(s0)
    ld	a1,-32(s0)
    ld	a0,-24(s0)
    jal	ra, __muldi3
    mv	a5,a0
    mv	a0,a5
    ld	ra,24(sp)
    ld	s0,16(sp)
    addi	sp,sp,32
    ret

main:
    addi	sp,sp,-48
    sd	ra,40(sp)
    sd	s0,32(sp)
    addi	s0,sp,48
    li	a5,6
    sd	a5,-24(s0)
    li	a5,5
    sd	a5,-32(s0)
    ld	a1,-32(s0)
    ld	a0,-24(s0)
    jal	ra, mul
    sd	a0,-40(s0)
    li	a5,0
    mv	a0,a5
    ld	ra,40(sp)
    ld	s0,32(sp)
    addi	sp,sp,48
    ret
    
__muldi3:
    mv	a2,a0
    li	a0,0
__m3_0:
    andi a3,a1,1
    beqz a3, __m3_1
    add	a0,a0,a2
__m3_1:
    srli a1,a1,0x1
    slli a2,a2,0x1
    bnez a1, __m3_0
    ret
