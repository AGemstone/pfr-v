main:       add x1, xzr, xzr
            add x29, xzr, xzr
            add x29, x29, #256
loop0:      sub x29, x29, #1
            stur x1, [x0, #0]
            add x1, x1, #1
            cbnz x29, loop0
            add xzr, xzr, xzr
            add xzr, xzr, xzr
            add xzr, xzr, xzr
            cbz xzr, main
            add xzr, xzr, xzr
            add xzr, xzr, xzr
            add xzr, xzr, xzr
            add xzr, xzr, xzr
            add xzr, xzr, xzr
