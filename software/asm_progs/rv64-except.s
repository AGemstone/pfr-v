start:
    nop
    nop
    /* mepc is not writable for now */
    /* Enable interrupts */
    csrsi mstatus, 8
    li a0, 1
    bnez a0, hoop
    /* Setup trap handler */
    /* No linker, hence no la instruction*/
    li t0, 0x2c
    csrw mtvec, t0
    /* Return from machine mode */
    mret
hoop:
    ebreak
    li a1, 2
    j main

trap_handle:
    nop
    mret

main:
    csrr a0, mstatus
    nop
    beqz zero, main

