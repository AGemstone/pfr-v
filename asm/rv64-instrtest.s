        add a0, a0, a0
        sd a0, 0(zero)
        ld a1, 0(zero)
        sub a1, a3, a1
        and a2, a1, a0
        add a2, a2, ra
        sd a2, 8(zero)
        or a2, a1, a0
        add a2, a2, ra
        sd a2, 16(zero)
loop:   bne a0, a1, loop
        add zero, zero, zero
loop2:  beq a0, a0, loop2
