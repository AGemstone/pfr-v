#!/usr/bin/python
import math
import subprocess as sp
import sys
import os

TOOLCHAIN = "riscv64-unknown-linux-gnu"
ENVIRONMENT = os.environ.copy()
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


def subp_run(cmd, capture_output=False):
    return sp.run(cmd.split(" "), capture_output=capture_output, text=True)


if len(sys.argv) < 3:
    print("Usage: ./export_opcode.py <output_dir> <file>")
    sys.exit(-1)

if sys.argv[2][-1] == "s":
    AS_FLAGS = "--warn --fatal-warnings"
    subp_run(f"{TOOLCHAIN}-as {sys.argv[2]} {AS_FLAGS}")

elif sys.argv[2][-1] == "c":
    CC_FLAGS = "-Wall -g -Wextra -mcmodel=medlow -ffreestanding"

    # Setup environment to use makefile later
    KERNEL = sys.argv[2].split("/")[1][:-2]
    ENVIRONMENT["KERNEL"] = KERNEL
    os.chdir("c_progs")

    # Patch to "fix" quirks of the architecture
    subp_run(f"{TOOLCHAIN}-gcc -S {CC_FLAGS} {KERNEL}.c -o {KERNEL}.s")
    prog = None
    with open(f"{KERNEL}.s", "r") as f:
        prog = map(lambda a: a.strip(), f.read().split("\n"))
        prog = filter(lambda a: a != "", prog)
        prog = "".join(map(instr_patch, prog))
    with open(f"{KERNEL}_patch.s", "w") as f:
        f.write(prog)

    # Final assembly
    subp_run(f"{TOOLCHAIN}-gcc -c {CC_FLAGS} {KERNEL}_patch.s -o {KERNEL}.o")
    sp.run(["make", "compile"], env=ENVIRONMENT)
    sp.run(["make", "clean_partial"], env=ENVIRONMENT)

else:
    print(".s for assembly, .c for c")

# Get .text section
subp_run(f"{TOOLCHAIN}-objcopy -O binary -j .text a.out text.dat")
cmd = "hexdump -v -f instr.fmt text.dat"  # Doesn't work with subprocces.run :/
with sp.Popen(cmd.split(" "), stdout=sp.PIPE, text=True) as p:
    text = p.communicate()[0].strip()[:-1].split("\n")

# # Get rodata to inject later in memory
out = subp_run(f"{TOOLCHAIN}-objcopy -O binary -j .rodata a.out rodata.dat",
               True)
rodata = []
rodata_length = 0
if not out.stderr:
    cmd = "hexdump -v -f data.fmt rodata.dat"
    with sp.Popen(cmd.split(" "), stdout=sp.PIPE, text=True) as p:
        rodata = p.communicate()[0].strip().split("\n")
        if rodata != ['']:
            rodata_length = len(rodata)
        rodata.reverse()
        print((rodata_length))
        # map()
rodata.append(f"32'h{hex(len(rodata)//2)[2:]}")
rodata_length += 1
# print(rodata)

# # Get rodata base address
# symtab = subp_run(f"{TOOLCHAIN}-objdump -t a.out", True).stdout.split("\n")
# index = [idx for idx, s in enumerate(symtab) if 'global_pointer' in s][0]
# symbol = "0x"+symtab[index].split(" ")[0]

disas = subp_run("riscv64-unknown-linux-gnu-objdump -d a.out", True).stdout
print(disas)

subp_run("rm a.out")
# Cleanup output of objdump
objdump_clean = disas.split(("\n"))
objdump_clean = filter(lambda x: x != "", objdump_clean)
objdump_clean = filter(lambda x: "\t" in x, objdump_clean)
objdump_clean = map(lambda x: x.split("\t"), objdump_clean)
# Parse instructions
instr_list = map(instr_parse, objdump_clean)
instr_list = list(instr_list)

text_length = len(text)
ADDR_BITS = int(math.log(text_length + rodata_length + 1)/math.log(2)) + 1
IMEM_SIZE = 2**ADDR_BITS

print(text_length, rodata_length, text_length + rodata_length, IMEM_SIZE)

module_write = "module imem #(parameter N = 32)(\n"
module_write += " " * 4 + f"input logic[{ADDR_BITS-1}:0] addr0, addr1,\n"
module_write += " " * 4 + "output logic[N-1:0] q0, q1\n"
module_write += ");\n"
module_write += " " * 4 + f"logic [N - 1:0] rom [0 : {IMEM_SIZE - 1}];\n"
module_write += " " * 4 + f"assign rom[0:{text_length - 1}] = " + "'{\n"
for opcode, mnemonic in zip(text, instr_list):
    module_write += " " * 8 + f"{opcode} {mnemonic}" + "\n"
module_write += " " * 4 + "};\n"
module_write += " " * 4 + \
    f"assign rom[{IMEM_SIZE - rodata_length }:{IMEM_SIZE - 1}] = " + "'{\n"
for data in rodata:
    module_write += " " * 8 + f"{data}" + "\n"
module_write += " " * 4 + "};\n"
module_write += " " * 4 +                                                      \
    f"assign rom [{text_length}:{IMEM_SIZE - rodata_length - 1}] = " +         \
    "'{" + f"({IMEM_SIZE - rodata_length -text_length})" + "{'0}};\n"
module_write += " " * 4 + "assign q0 = rom[addr0];\n"
module_write += " " * 4 + "assign q1 = rom[addr1];\n"
module_write += "endmodule"

os.chdir(CWD)
with open(f"{sys.argv[1]}/imem.sv", "w") as f:
    f.write(module_write)

# Adjust imem addressing
with open(f"{sys.argv[1]}/core.sv", "r") as f:
    lines = f.readlines()
    index = [idx for idx, s in enumerate(lines) if 'imem instrMem' in s][0]
    addr0_signal = "{DM_addr[15], DM_addr["+f"{ADDR_BITS+1}"+":3]}"
    lines[index] = f"    imem instrMem (.addr0(IM_address[{ADDR_BITS + 1}:2]),\n"
    lines[index+1] = f"                   .addr1({addr0_signal}),\n"

with open(f"{sys.argv[1]}/core.sv", "w") as f:
    f.write("".join(lines))
