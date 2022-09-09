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

        andi a4, a1, -1
        sd a4, 24(zero)

        ori a5, a1, -1
        sd a5, 32(zero)
        
        lui a6, 1000000
        sd a6, 40(zero)

        AUIPC a7, 1000000
        sd a7, 48(zero)

        bne ra, zero, loop
        add zero, zero, zero
loop:  
        beq zero, zero, loop
        add zero, zero, zero
