TOOLCHAIN=riscv64-unknown-linux-gnu
CC_FLAGS=-Wall -g -Wextra -mcmodel=medany -ffreestanding
LIBGCC=/opt/riscv/lib/gcc/riscv64-unknown-linux-gnu/12.1.0/include/
LD_FLAGS=-I$(LIBGCC) -nostdlib

normal:
	$(TOOLCHAIN)-gcc -c $(CC_FLAGS) $(KERNEL).c -o $(KERNEL).o

compile:
	$(TOOLCHAIN)-as -c entry.s -o entry.o -march=rv64i
	$(TOOLCHAIN)-ld -T linker.ld $(LD_FLAGS) $(KERNEL).o entry.o -o a.out	

clean:
	rm *.o *.out *_patch

gcc: normal compile