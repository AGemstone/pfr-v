#!/usr/bin/python
from parse_helpers import *
import math
import subprocess as sp
import sys
import os
import numpy as np

TOOLCHAIN = "riscv64-unknown-linux-gnu"
ENVIRONMENT = os.environ.copy()
CWD = os.getcwd()

if len(sys.argv) < 3:
    print("Usage: ./export_opcode.py <output_dir> <file>")
    sys.exit(-1)

if sys.argv[2][-1] == "s":
    AS_FLAGS = "--warn --fatal-warnings"
    subp_run(f"{TOOLCHAIN}-as {sys.argv[2]} {AS_FLAGS}")

elif sys.argv[2][-1] == "c":
    FILEPATH = sys.argv[2].split("/")
    os.chdir("".join(FILEPATH[:-1]))
    print("".join(FILEPATH[:-1]))
    ENVIRONMENT["KERNEL"] = FILEPATH[-1][:-2]
    sp.run(["make", "patch"], env=ENVIRONMENT)
    sp.run(["make", "compile"], env=ENVIRONMENT)
    sp.run(["make", "clean_partial"], env=ENVIRONMENT)

else:
    print(".s for assembly, .c for c")

# Get .text section
subp_run(f"{TOOLCHAIN}-objcopy -O binary -j .text a.out text.dat")
cmd = "hexdump -v -f instr.fmt text.dat"  # Doesn't work with subprocces.run :/
with sp.Popen(cmd.split(" "), stdout=sp.PIPE, text=True) as p:
    text = p.communicate()[0].strip().split("\n")

# Get rodata to inject later in memory
out = subp_run(
    f"{TOOLCHAIN}-objcopy -O binary -j .rodata a.out rodata.dat", True)
rodata = []
if not out.stderr:
    cmd = "hexdump -v -f data.fmt rodata.dat"
    with sp.Popen(cmd.split(" "), stdout=sp.PIPE, text=True) as p:
        rodata = p.communicate()[0].strip().split("\n")
        if rodata == ['']:
            rodata = ["0"*16]

# Get global pointer address
symtab = subp_run(f"{TOOLCHAIN}-objdump -x .symtab a.out", True)
symtab = symtab.stdout.split("\n")
index = index_where_str_in(symtab, "global_pointer")
gp_address = "{}".format(symtab[index].split(" ")[0])
gp_address = int(gp_address, 16) >> 3

# Get patched dissassembly for debugging
disas = subp_run(f"{TOOLCHAIN}-objdump -d a.out", True).stdout
print(disas)

text_length = len(text)
ADDR_BITS = 1
if text_length > 0:
    ADDR_BITS = int(math.log(text_length)/math.log(2)) + 1
IMEM_SIZE = 2**ADDR_BITS

# Data memory initialization
# Fill memory with zeros
dmem_init = ""
for i in range(4096):
    record = f"08{hex(i)[2:]:0>4}00{'0'*16}"
    checksum = map(lambda a: int(f"0x{a}", 16),
                   [record[i:i+2] for i in range(0, len(record), 2)])
    checksum = sum(checksum)
    dmem_init += f":{record}{hex((1 << 32) + (-checksum))[-2:]}\n"
dmem_init = dmem_init.split("\n")
# Proper initialization of data memory
for i in range(len(rodata)):
    index = gp_address + i
    record = f"08{hex(index)[2:]:0>4}00{rodata[i]}"
    checksum = map(lambda a: int(f"0x{a}", 16),
                   [record[i:i+2] for i in range(0, len(record), 2)])
    checksum = sum(checksum)
    dmem_init[index] = f":{record}{hex((1 << 32) + (-checksum))[-2:]}"
dmem_init = "\n".join(dmem_init)
dmem_init += ":00000001ff"

# Instruction memory initialization
text += ["0"*8 for _ in range(1024 - text_length)]
imem_init = ""
imem_init_mif = "-- begin_signature\n"
imem_init_mif += "-- imem\n"
imem_init_mif += "-- end_signature\n"
imem_init_mif += "WIDTH=32;\n"
imem_init_mif += "DEPTH=1024;\n\n"
imem_init_mif += "ADDRESS_RADIX=UNS;\n"
imem_init_mif += "DATA_RADIX=HEX;\n\n"
imem_init_mif += "CONTENT BEGIN\n"
for i in range(len(text)):
    imem_init_mif += f"{i} : {text[i]}\n"
    imem_init += f"{text[i]}\n"
imem_init_mif += "END;"


dat_files = ["text.dat", "rodata.dat"]
subp_run(f"rm a.out {' '.join(dat_files)}")
os.chdir(CWD)


# Update intializaion files
with open(f"{sys.argv[1]}/dmem_init.hex", "w") as f:
    f.write(dmem_init)

with open(f"{sys.argv[1]}/imem_init.txt", "w") as f:
    f.write(imem_init.strip())

# Link to imem mif in quartus project db!
with open(f"imem_init.mif", "w") as f:
    f.write(imem_init_mif)