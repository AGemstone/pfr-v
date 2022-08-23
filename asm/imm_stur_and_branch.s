loop:	sub x4, x4, #1	
	add xzr, xzr, xzr
	add xzr, xzr, xzr
	add xzr, xzr, xzr
	add x1, x1, #1
	add xzr, xzr, xzr
	add xzr, xzr, xzr
	add xzr, xzr, xzr
	cbnz x4, loop
	add xzr, xzr, xzr
	add xzr, xzr, xzr
	add xzr, xzr, xzr
	stur x1, [x0, #0]
infl: 	cbz xzr, infl
