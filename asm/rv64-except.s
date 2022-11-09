start:
    nop
    nop
    /* enable interrupts */
    csrwi mstatus, 8
    li t0, 0x70
    csrw mtvec, t0
    ebreak
    j main

trap_handle:
    csrr a0, mstatus
    mret

main:
    csrr a0, mstatus
    beqz zero, main

