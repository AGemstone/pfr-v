            addi a1, zero, 255
start:      add a0, zero, zero
loop:       addi a0, a0, 1
            sd a0, 0(zero)
            bne a0, a1, loop
            beq zero, zero, start
