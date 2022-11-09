start:
    nop
    nop
    /* mepc is not writable for now */
    /* Enable interrupts */
    csrsi mstatus, 8
    bnez a0, hoop
    /* Setup trap handler */
    /* No linker, hence no la instruction*/
    li t0, 0x2c
    sll t0, t0, 2
    csrw mtvec, t0
    li a0, 1
    /* Return from machine mode */
    mret
hoop:
    ebreak
    j main

trap_handle:
    nop
    mret

main:
    csrr a0, mstatus
    nop
    beqz zero, main

