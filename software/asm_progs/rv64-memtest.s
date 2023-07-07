.section .text
nop
nop
sd zero, 0(zero)
addi t6, t6, 8
li a0, 0x0102030405060708
sb a0, 0(t6)
sb a0, 1(t6)
sb a0, 7(t6)
sh a0, 8(t6)
sh a0, 9(t6)
sh a0, 15(t6)
sw a0, 16(t6)
sw a0, 17(t6)
sw a0, 22(t6)

sd a0, 24(t6)
sd a0, 25(t6)

lb a1, 1(t6)
lbu a2, 1(t6)
sd t1, 0(zero)
addi t1, t1, 1
ebreak
lab: j lab
