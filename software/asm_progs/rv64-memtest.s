nop
nop
li a0, -1
sb a0, 0(zero)
sb a0, 1(zero)
sb a0, 7(zero)

sh a0, 8(zero)
sh a0, 9(zero)
sh a0, 15(zero)

sw a0, 16(zero)
sw a0, 17(zero)
sw a0, 22(zero)

sd a0, 24(zero)
sd a0, 25(zero)

lb a1, 1(zero)
lbu a2, 1(zero)
lab: j lab
