#!/usr/bin/python
import math
import subprocess as sp
import sys
import os

TOOLCHAIN = "riscv64-unknown-linux-gnu"
CWD = os.getcwd()

def instr_parse(x):
    res = ""
    try:
        res = f"//{x[0]} {x[2]} {x[3]}"
    except:
        res = f"//{x[0]} {x[2]}"
    return res


def instr_patch(instr):
    patch = f"{instr}\n"
    if instr[:2] in ["sd"]:
        patch += "nop\n"
    elif instr[:2] in ["ld"]:
        patch += f"{instr}\n"
    return patch

# Simple helper function to pass a string to subprocess.run


def subp_run(cmd, **kwargs):
    sp.run(cmd.split(" "))


if len(sys.argv) < 3:
    print("Usage: ./export_opcode.py <output_dir> <file>")
    sys.exit(-1)

if sys.argv[2][-1] == "s":
    AS_FLAGS = "--warn --fatal-warnings"
    subp_run(f"{TOOLCHAIN}-as {sys.argv[2]} {AS_FLAGS}")

elif sys.argv[2][-1] == "c":
    TOOLCHAIN = "riscv64-unknown-linux-gnu-gcc"
    CC_FLAGS = "-Wall -g -Wextra -mcmodel=medany -ffreestanding"
    # Setup environment to use makefile later
    environment = os.environ.copy()
    KERNEL = sys.argv[2].split("/")[1][:-2]
    environment["KERNEL"] = KERNEL
    os.chdir("c_progs")

    # Patch to "fix" quirks of the architecture
    subp_run(f"{TOOLCHAIN} -S {CC_FLAGS} {KERNEL}.c -o {KERNEL}.s")
    prog = None
    with open(f"{KERNEL}.s", "r") as f:
        prog = map(lambda a: a.strip(), f.read().split("\n"))
        prog = filter(lambda a: a != "", prog)
        prog = "".join(map(instr_patch, prog))
    with open(f"{KERNEL}_patch.s", "w") as f:
        f.write(prog)

    # Final assembly
    subp_run(f"{TOOLCHAIN} -c {CC_FLAGS} {KERNEL}_patch.s -o {KERNEL}.o")
    sp.run(["make", "compile"], env=environment)

else:
    print(".s for assembly, .c for c")

cmd = "riscv64-unknown-linux-gnu-objdump -d a.out"
objdump_out = sp.run(cmd.split(" "), capture_output=True).stdout.decode("utf8")
subp_run("rm a.out")
print(objdump_out)

# Cleanup output of objdump
objdump_clean = objdump_out.split(("\n"))
objdump_clean = filter(lambda x: x != "", objdump_clean)
objdump_clean = filter(lambda x: "\t" in x, objdump_clean)
objdump_clean = map(lambda x: x.split("\t"), objdump_clean)
objdump_clean = list(objdump_clean)

# Parse instructions
instr_list = map(instr_parse, objdump_clean)
instr_list = list(instr_list)

# Parse opcodes
opcode_list = map(lambda x: x[1].strip(), objdump_clean)
opcode_list = map(lambda x: f"'h{x},", opcode_list)
opcode_list = list(opcode_list)
opcode_list[-1] = f"{opcode_list[-1][:-1]} "

prog_length = len(opcode_list)
ADDR_BITS = int(math.log(prog_length)/math.log(2)) +1
IMEM_SIZE = 2**ADDR_BITS

module_write = "module imem #(parameter N = 32)(\n"
module_write += " " * 4 + f"input logic[{ADDR_BITS-1}:0] addr,\n"
module_write += " " * 4 + "output logic[N-1:0] q\n"
module_write += ");\n"
module_write += " " * 4 + f"logic [N - 1:0] rom [0 : {IMEM_SIZE - 1}];\n"
module_write += " " * 4 + f"assign rom[0:{prog_length - 1}] = " + "'{\n"
for i in range(prog_length):
    instruction = instr_list[i].split(":")[1].strip().split(" ")[0]
    module_write += " " * 8 + f"{opcode_list[i]} {instr_list[i]}" + "\n"
module_write += " " * 4 + "};\n"
module_write += " " * 4 + \
    f"assign rom [{prog_length}:{IMEM_SIZE - 1}] = " + \
    "'{" + f"({IMEM_SIZE}-{prog_length})" + "{'0}};\n"
module_write += " " * 4 + "assign q = rom[addr];\n"
module_write += "endmodule"

if prog_length > IMEM_SIZE:
    print(f"WARN: Program length excedes address space ({IMEM_SIZE} lines)")

os.chdir(CWD)
with open(f"{sys.argv[1]}/imem.sv", "w") as f:
    f.write(module_write)
