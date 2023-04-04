setup:
    add x1, xzr, xzr
    add x2, xzr, xzr
    add x2, x2, #255    
loop: 
    stur x1, [x0, #0]
    add x1, x1, 1
    sub x2, x2, 1
    cbnz x2, loop
    cbz xzr, setup
