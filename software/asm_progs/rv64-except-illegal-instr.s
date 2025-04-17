_start:
    # 1️⃣ Ensure we are in Machine Mode
    csrr a5, mstatus         # Read current mstatus
    li t0, 0x1800            # MPP = 0b11 (Machine Mode) << 11
    or a5, a5, t0            # Set MPP to Machine Mode
    csrw mstatus, a5         # Write back to mstatus

    # 2️⃣ Set mtvec to `trap_handle`
    li t1, 0x4c       # Load address of exception handler
    nop
    nop
    nop
    csrr a2, mepc            # Read mepc (should be 0 at this point)

    # 3️⃣ Enable MIE (not necessary for exceptions, but useful for interrupts)
    csrw mtvec, t1            # Set mtvec to point to trap_handle

    # 4️⃣ Read mepc BEFORE sret
    csrrs t0, mstatus, 0x8   # Set MIE bit (bit 3)

    # 5️⃣ Attempt to execute sret (should cause illegal instruction)
    sret                     # This should trigger an exception

    # 6️⃣ If execution reaches here, sret did NOT cause an exception
    nop
    nop
    li a3, 1                 # Indicate failure
    nop
    nop
    j main

trap_handle:
    li a4, 2                 # Indicate exception occurred
    j trap_handle             # Infinite loop for debugging

main:
    csrr a0, mstatus
    nop
    beqz zero, main
