start:
        add zero, zero, zero
        addi a0, a0, 1
        nop
        nop
        nop
        sd a0, 0(zero)
        nop
        nop
        nop
loop:   beq zero, zero, loop

