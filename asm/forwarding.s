        add	x1, x1, #0x1
  		add	x1, x1, #0x1
  		add	x1, x1, #0x1
        and xzr, xzr, xzr
		add	x1, x1, #0x1
		and xzr, xzr, xzr
		add	x1, x1, #0x1
  		stur	x1, [x0]
  		ldur	x2, [x0]
  		add	x2, x2, x1
  		stur	x2, [x0, #8]
loop:   cbz xzr, loop

