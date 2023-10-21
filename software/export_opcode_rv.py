#!/usr/bin/python
from parse_helpers import *
import math
import subprocess as sp
import sys
import os
import numpy as np

TOOLCHAIN = "riscv64-unknown-elf"
ENVIRONMENT = os.environ.copy()
CWD = os.getcwd()

if len(sys.argv) < 3:
    print("Usage: ./export_opcode.py <output_dir> <file>")
    sys.exit(-1)

FILEPATH = sys.argv[2].split("/")
os.chdir("".join(FILEPATH[:-1]))

if sys.argv[2][-1] == "s":
    AS_FLAGS = "--warn --fatal-warnings -mabi=lp64"
    # FILEPATH = sys.argv[2].split("/")
    # os.chdir("".join(FILEPATH[:-1]))
    # print("".join(FILEPATH[:-1]))

    subp_run(f"{TOOLCHAIN}-as {FILEPATH[-1]} {AS_FLAGS}")

elif sys.argv[2][-1] == "c":

    ENVIRONMENT["KERNEL"] = FILEPATH[-1][:-2]
    sp.run(["make", "patch"], env=ENVIRONMENT)
    sp.run(["make", "compile"], env=ENVIRONMENT)
    sp.run(["make", "clean_partial"], env=ENVIRONMENT)

else:
    print(".s for assembly, .c for c")


# Get symbol table
symtab = subp_run(f"{TOOLCHAIN}-readelf -s a.out", True).stdout.split("\n")

# Data memory initialization (HEX)
# Fill memory with zeros
dmem_init = []
for i in range(4096):
    record = f"08{hex(i)[2:]:0>4}00{'0'*16}"
    checksum = map(lambda a: int(f"0x{a}", 16),
                   [record[i:i+2] for i in range(0, len(record), 2)])
    checksum = sum(checksum)
    dmem_init.append(f":{record}{hex((1 << 32) + (-checksum))[-2:]}")

# Get rodata sections to initialize memory
rodata = []
sections = [symbol.strip().split()
            for i, symbol in enumerate(symtab) if "SECTION" in symbol]
rodata_sections = [s for s in sections if "rodata" in s[-1]]
for section in rodata_sections:
    name = section[-1]
    address = int(section[1], 16) >> 3
    out = subp_run(
        f"{TOOLCHAIN}-objcopy -O binary -j {name} a.out rodata.dat", True)
    cmd = "hexdump -v -f data.fmt rodata.dat"
    with sp.Popen(cmd.split(" "), stdout=sp.PIPE, text=True) as p:
        rodata = p.communicate()[0].strip().split("\n")
    # Proper initialization of data memory
    for i in range(len(rodata)):
        index = address + i
        record = f"08{hex(index)[2:]:0>4}00{rodata[i]}"
        checksum = map(lambda a: int(f"0x{a}", 16),
                       [record[i:i+2] for i in range(0, len(record), 2)])
        checksum = sum(checksum)
        dmem_init[index] = f":{record}{hex((1 << 32) + (-checksum))[-2:]}"
dmem_init.append(":00000001ff")
dmem_init = "\n".join(dmem_init)


# Get .text section
subp_run(f"{TOOLCHAIN}-objcopy -O binary -j .text a.out text.dat")
cmd = "hexdump -v -f instr.fmt text.dat"  # Doesn't work with subprocces.run :/
with sp.Popen(cmd.split(" "), stdout=sp.PIPE, text=True) as p:
    text = p.communicate()[0].strip().split("\n")

# Get patched dissassembly for debugging
disas = subp_run(f"{TOOLCHAIN}-objdump -d a.out", True).stdout
print(disas)

text_length = len(text)

# Instruction memory initialization
text += ["0"*8 for _ in range(1024 - text_length)]
imem_init = ""
for i in range(len(text)):
    imem_init += f"{text[i]}\n"
# print(imem_init)
# imem_init_mif = "-- begin_signature\n"
# imem_init_mif += "-- imem\n"
# imem_init_mif += "-- end_signature\n"
# imem_init_mif += "WIDTH=32;\n"
# imem_init_mif += "DEPTH=1024;\n\n"
# imem_init_mif += "ADDRESS_RADIX=UNS;\n"
# imem_init_mif += "DATA_RADIX=BIN;\n\n"
# imem_init_mif += "CONTENT BEGIN\n"
# for i in range(len(text)-1,-1,-1):
#     mif_word = bin(int(f"0x{text[i]}",16))[2:]
#     imem_init_mif += f"\t{i} :\t{mif_word:0>32};\n"
# imem_init_mif += "END;\n"

# imem_init_hex = []
# for i in range(1024):
#     record = f"04{hex(i)[2:]:0>4}00{'0'*16}"
#     checksum = map(lambda a: int(f"0x{a}", 16),
#                    [record[i:i+2] for i in range(0, len(record), 2)])
#     checksum = sum(checksum)
#     imem_init_hex.append(f":{record}{hex((1 << 32) + (-checksum))[-2:]}")
# for i in range(len(text)):
#     record = f"04{hex(i)[2:]:0>4}00{text[i]}"
#     checksum = map(lambda a: int(f"0x{a}", 16),
#                    [record[i:i+2] for i in range(0, len(record), 2)])
#     checksum = sum(checksum)
#     imem_init_hex[i] = f":{record}{hex((1 << 32) + (-checksum))[-2:]}"
# imem_init_hex.append(":00000001ff")
# imem_init_hex = "\n".join(imem_init_hex)

# Clean binary files
dat_files = ["text.dat", "rodata.dat"]
# subp_run(f"rm a.out {' '.join(dat_files)}")
os.chdir(CWD)

# Update intializaion files
with open(f"{sys.argv[1]}/dmem_init.hex", "w") as f:
    f.write(dmem_init)

with open(f"{sys.argv[1]}/imem_init.txt", "w") as f:
    f.write(imem_init.strip())

# Link to imem mif in quartus project db!
# with open(f"imem_init.mif", "w") as f:
#     f.write(imem_init_mif)

# with open(f"{sys.argv[1]}/imem_init.hex", "w") as f:
#     f.write(imem_init_hex)
