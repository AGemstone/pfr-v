TOOLCHAIN=riscv64-unknown-linux-gnu
LIBGCC=/opt/riscv/lib/gcc/riscv64-unknown-elf/12.2.0/libgcc.a
CC_FLAGS=-mcmodel=medlow -Wall -Wextra -pedantic -ffreestanding -march=rv64i \
		 -mabi=lp64 -I./lib
LD_FLAGS=-nostdlib -static 
EXTRASOURCES=$(filter-out #include,\
			 $(patsubst "%.h","%.c",\
			 $(shell cat $(KERNEL)/$(KERNEL).c | grep -iE \#include.\")))
RV=1

ifdef SOFTMUL
	EXTRALIBS+=$(TOOLCHAIN)-ar -xv $(LIBGCC) muldi3.o umoddi3.o _umoddi3;
endif

normal:
	$(foreach UNIT, $(EXTRASOURCES), $(TOOLCHAIN)-gcc -c $(CC_FLAGS) -Os \
		lib/$(UNIT) -o $(UNIT).o;)
	$(TOOLCHAIN)-gcc -c $(CC_FLAGS) $(KERNEL)/$(KERNEL).c -o $(KERNEL).o 

patch:
	$(foreach UNIT, $(EXTRASOURCES), ./rv_binary_patcher.py lib/$(UNIT) \
		$(CC_FLAGS) -Os;)
	./rv_binary_patcher.py $(KERNEL)/$(KERNEL).c $(CC_FLAGS)
	
compile:
	$(EXTRALIBS)
	$(TOOLCHAIN)-as -c entry.s -o entry.o -march=rv64i
	$(TOOLCHAIN)-ld -T linker.ld $(LD_FLAGS) *.o -o a.out

clean_partial:
	rm -r *.o *_patch.s $(KERNEL).s __pycache__

clean: clean_partial
	rm a.out
	
gcc: normal compile