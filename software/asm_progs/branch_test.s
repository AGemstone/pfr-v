_start:
    # Initialize registers
    li t0, 10       # Load immediate 10 into t0
    li t1, 20       # Load immediate 20 into t1
    li t2, 0        # Zero t2

    # Test 1: Branch with dependency
    add t3, t0, t1      # t3 = t0 + t1
    beq t3, t1, skip    # If t3 == t1, skip the next instruction
    li t2, 1            # Set t2 to 1 (shouldn't execute if branch is correct)

skip:
    # Test 2: Back-to-back branches
    li t4, 5
    li t5, 5
    bne t4, t5, fail    # t4 == t5, so it shouldn't branch
    beq t4, t5, pass    # t4 == t5, so it should branch to pass

fail:
    li t2, 2            # If failed, set t2 to 2
    j end

pass:
    li t2, 3            # If passed, set t2 to 3

end:

    # Exit program (simulation environments like Spike handle this)
    li a7, 10           # syscall for exit
    ecall
