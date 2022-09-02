start:
        add zero, zero, zero
        add zero, zero, zero
        
        add a0, a0, a0
        sd a0, 0(zero)

        ld a1, 0(zero)
        add a1, a1, 1

        and a2, a1, a0
        sd a2, 8(zero)

        or a3, a1, a0
        sd a3, 16(zero)

loop:   
        bne a0, a0, loop
        add zero, zero, zero
loop2:  
        beq zero, zero, loop2
        add zero, zero, zero
