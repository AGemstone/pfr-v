#!/bin/python
from parse_helpers import *
import sys
import os
CWD = os.getcwd()

TOOLCHAIN = "riscv64-unknown-linux-gnu"
ENVIRONMENT = os.environ.copy()
CC_FLAGS = " ".join(sys.argv[2:])

# Setup environment to use makefile later
print(sys.argv[1])
FILEPATH = sys.argv[1].split("/")
UNIT = FILEPATH[-1][:-2]
DIR = "/".join(sys.argv[1].split("/")[:-1])
ENVIRONMENT["UNIT"] = UNIT

# Patch to "fix" quirks of the architecture
subp_run(f"{TOOLCHAIN}-gcc -S {CC_FLAGS} {DIR}/{UNIT}.c -o {UNIT}.s")
prog = None
with open(f"{UNIT}.s", "r") as f:
    prog = map(lambda a: a.strip(), f.read().split("\n"))
    prog = filter(lambda a: a != "", prog)
    prog = "".join(map(instr_patch, prog))
with open(f"{UNIT}_patch.s", "w") as f:
    f.write(prog)

# Final assembly
subp_run(f"rm {UNIT}.s")
subp_run(f"{TOOLCHAIN}-gcc -c {CC_FLAGS} {UNIT}_patch.s -o {UNIT}.o")
