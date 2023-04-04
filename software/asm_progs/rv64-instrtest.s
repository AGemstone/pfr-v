start:
        addw zero, zero, zero
        add zero, zero, zero
        
        add a0, a0, a0
        add a1, a1, 1
        and a2, a1, a0
        or a3, a1, a0
        and a4, a1, -1
        or a5, a1, -1
        sb a5, 0(zero)
        sh a5, 8(zero)
        sw a5, 16(zero)
        sd a5, 24(zero)
        
        ld a5, 24(zero)
        sd a5, 32(zero)
        lw a5, 16(zero)
        sw a5, 40(zero)
        lh a5, 8(zero)
        sh a5, 48(zero)
        lb a5, 0(zero)
        sb a5, 56(zero)
        
        lui a6, 4096
        sd a6, 64(zero)
        AUIPC a7, 1000000
        sd a7, 72(zero)

        add a0, zero, 1
        add a1, zero, 32
        add a2, zero, 42
        add a3, zero, -1

        bltu a0, zero, l0
        add zero, zero, zero
l0:
        bltu zero, a0, l1
        add zero, zero, zero
l1:
        bltu zero, zero, l2
        add zero, zero, zero
l2:
        bltu a2, a1, l3
        add zero, zero, zero
l3:
        bltu a1, a2, l4
        add zero, zero, zero
l4:
        bltu a3, zero, l5
        add zero, zero, zero
l5:
        bltu a3, a0, l6
        add zero, zero, zero
l6:
        bltu a0, a3, l7
        add zero, zero, zero
l7:
        bne zero, zero, loop
        add zero, zero, zero
        bne ra, zero, loop
        add zero, zero, zero
loop:  
        beq zero, zero, loop
        add zero, zero, zero
