TOOLCHAIN=riscv64-unknown-linux-gnu
LIBGCC=/opt/riscv/lib/gcc/riscv64-unknown-elf/12.2.0/libgcc.a
CC_FLAGS=-mcmodel=medlow -Wall -Wextra -pedantic -ffreestanding -march=rv64i -mabi=lp64
LD_FLAGS=-nostdlib
RV=1

ifdef ENABLEMUL
	EXTRALIBS+=$(TOOLCHAIN)-ar -xv $(LIBGCC) muldi3.o
endif

normal:
	$(TOOLCHAIN)-gcc -c $(CC_FLAGS) $(KERNEL).c -o $(KERNEL).o 

compile:
	$(EXTRALIBS)
	$(TOOLCHAIN)-as -c entry.s -o entry.o -march=rv64i
	$(TOOLCHAIN)-ld -T linker.ld $(LD_FLAGS) *.o -o a.out

clean_partial:
	rm *.o *_patch.s $(KERNEL).s *.dat

clean: clean_partial
	rm a.out

gcc: normal compile