        add	a1, a1, 1
  		add	a1, a1, 1
  		add	a1, a1, 1
        ADD x0, x0, 0
		add	a1, a1, 1
		ADD x0, x0, 0
		add	a1, a1, 1
  		sd  x1, [x0, #0]
  		ld  x2, [x0, #0]
  		add	x2, x2, x1
  		sd  x2, [x0, #8]
loop:   beq x0, x0, loop

