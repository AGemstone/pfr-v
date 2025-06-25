.section .text
.globl _start

_start:
    # Define a base address register
    li s0, 0x100               # Load base address into s0

    # Store values directly into memory at specific addresses using s0 as base
    li t1, 0x12345678           # Value 1
    nop
    sd t1, 0(s0)                # Store Value 1 at address in s0 (0x100)

    li t2, 0x87654321           # Value 2
    sd t2, 8(s0)                # Store Value 2 at address (0x100 + 8)

    li t3, 0x11223344           # Value 3
    sd t3, 16(s0)               # Store Value 3 at address (0x100 + 16)

    li t4, 0x55667788           # Value 4
    sd t4, 24(s0)               # Store Value 4 at address (0x100 + 24)

    # Load values back from memory to verify correctness
    ld t1, 0(s0)                # Load Value 1 back into t1
    ld t2, 8(s0)                # Load Value 2 back into t2
    ld t3, 16(s0)               # Load Value 3 back into t3
    ld t4, 24(s0)               # Load Value 4 back into t4

    # Branch test
    beq t1, t1, skip            # Always true branch to skip

skip:
    # Infinite loop to end program
done:
    j done                      # Loop forever
