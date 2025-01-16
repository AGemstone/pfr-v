    .text
    .globl _start
_start:
    # Inicializar registros
    li t0, 10           # t0 = 10
    li t1, 20           # t1 = 20
    li t2, 10           # t2 = 10
    li t3, 30           # t3 = 30
    li a0, 0            # a0 = 0 (usado como registro temporal adicional)
    li a1, 0            # a1 = 0 (usado como registro temporal adicional)

    # Probar BEQ (Branch if Equal)
    beq t0, t2, label_beq    # Branch si t0 == t2
    add a0, t0, t1           # Hazard: No debería ejecutarse si se toma el branch
label_beq:
    sub a0, t0, t1           # Ejecuta si se toma el branch

    # Probar BNE (Branch if Not Equal)
    bne t0, t1, label_bne    # Branch si t0 != t1
    add a1, t1, t2           # Hazard: No debería ejecutarse si se toma el branch
label_bne:
    sub a1, t1, t2           # Ejecuta si se toma el branch

    # Probar BLT (Branch if Less Than, signed)
    blt t0, t1, label_blt    # Branch si t0 < t1
    add a0, t2, t3           # Hazard: No debería ejecutarse si se toma el branch
label_blt:
    sub a0, t3, t2           # Ejecuta si se toma el branch

    # Probar BGE (Branch if Greater or Equal, signed)
    bge t1, t0, label_bge    # Branch si t1 >= t0
    add a1, t0, t3           # Hazard: No debería ejecutarse si se toma el branch
label_bge:
    sub a1, t3, t0           # Ejecuta si se toma el branch

    # Probar BLTU (Branch if Less Than, unsigned)
    bltu t0, t1, label_bltu  # Branch si t0 < t1 (unsigned)
    add a0, t2, t3           # Hazard: No debería ejecutarse si se toma el branch
label_bltu:
    sub a0, t3, t2           # Ejecuta si se toma el branch

    # Probar BGEU (Branch if Greater or Equal, unsigned)
    bgeu t1, t0, label_bgeu  # Branch si t1 >= t0 (unsigned)
    add a1, t0, t3           # Hazard: No debería ejecutarse si se toma el branch
label_bgeu:
    sub a1, t3, t0           # Ejecuta si se toma el branch

    # Probar escenarios de hazard
    # Data hazard con forwarding
    add t0, t1, t2           # Write-back de t0 ocurre tarde
    beq t0, t2, label_hazard # Branch usa t0 antes de que se envíe por forwarding
    nop                      # Delay para simulación
label_hazard:
    sub a0, t0, t3           # Hazard: Verifica forwarding correctamente

    # Control hazard
    beq t1, t2, label_ctrl   # Branch poco probable
    add a1, t1, t2           # Instrucción especulativa
label_ctrl:
    sub a1, t2, t3           # Ejecuta solo si se toma el branch

    # Fin de pruebas
    li a7, 10                # Syscall para salir
    ecall
