start:
        addi a0, a0, 1024
        auipc sp, 0x2
        addi sp, sp, -4
        sd a0, 24(sp)
        nop
        nop
        nop
        sd sp, 16(sp)
        nop
        nop
        nop
loop:   beq zero, zero, loop

