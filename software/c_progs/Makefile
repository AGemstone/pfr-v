TOOLCHAIN=riscv64-unknown-linux-gnu
# LIBGCC=/opt/riscv/lib/gcc/riscv64-unknown-linux-gnu/12.1.0/
# LIBGCC=/opt/riscv/riscv64-unknown-linux-gnu/lib
RV=1
LIBGCC=/opt/riscv/lib/gcc/riscv64-unknown-elf/12.2.0/libgcc.a
CC_FLAGS=-Wall -g -Wextra -ffreestanding
LD_FLAGS=-nostdlib


normal:
	$(TOOLCHAIN)-gcc -c $(CC_FLAGS) $(KERNEL).c -o $(KERNEL).o

compile:
	$(TOOLCHAIN)-ar -xv  $(LIBGCC) muldi3.o
	$(TOOLCHAIN)-as -c entry.s -o entry.o -march=rv64i
	$(TOOLCHAIN)-ld -T linker.ld $(LD_FLAGS) $(KERNEL).o muldi3.o entry.o -o a.out	

clean_partial:
	rm *.o *_patch.s $(KERNEL).s

clean: clean_partial
	rm a.out

gcc: normal compile