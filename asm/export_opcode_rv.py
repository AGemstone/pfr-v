#!/usr/bin/python
import subprocess as sp
import sys

TOOLCHAIN = "riscv64-unknown-linux-gnu"


def instr_parse(x):
    res = ""
    try:
        res = f"//{x[0]} {x[2]} {x[3]}"
    except:
        res = f"//{x[0]} {x[2]}"
    return res


if len(sys.argv) < 3:
    print("Usage: ./export_opcode.py <output_dir> <file>")

    sys.exit(-1)

if sys.argv[2][-1] == "s":
    ASARGS = "--warn --fatal-warnings"
    cmd =f"{TOOLCHAIN}-as {sys.argv[2]} {ASARGS}".split(" ")
    sp.run(cmd)
elif sys.argv[2][-1] == "c":
    CCARGS = "-Wall -march=rv64i -mabi=lp64 -nostdlib -Wl,--section-start=.text=0x0"
    cmd = f"{TOOLCHAIN}-gcc {sys.argv[2]} {CCARGS}".split(" ")
    sp.run(cmd)
else:
    print(".s for assembly, .c for c")
cmd = "riscv64-unknown-linux-gnu-objdump -d a.out".split(" ")
out = sp.run(cmd, capture_output=True).stdout.decode("utf8")
print(out)
out_list = out.split(("\n"))
out_list = filter(lambda x: x != "", out_list)
out_list = filter(lambda x: "\t" in x, out_list)
out_list = map(lambda x: x.split("\t"), out_list)
out_list = list(out_list)
instr_list = map(instr_parse, out_list)
op_list = map(lambda x: x[1].strip(), out_list)
op_list = map(lambda x: f"'h{x},", op_list)
op_list = list(op_list)
instr_list = list(instr_list)
op_list[-1] = f"{op_list[-1][:-1]} "
prog_len = len(op_list)
if prog_len > 64:
    print("WARN: Program length excedes address space (64 lines)")
str_out = "module imem #(parameter N = 32)(\n"
str_out += " " * 4 + "input logic[5:0] addr,\n"
str_out += " " * 4 + "output logic[N-1:0] q\n"
str_out += ");\n"
str_out += " " * 4 + "logic [N - 1:0] rom [0 : 63];\n"
str_out += " " * 4 + f"localparam int prog_leng = {prog_len};\n"
str_out += " " * 4 + "assign rom[0:prog_leng-1] = '{\n"
for i in range(prog_len):
    str_out += " " * 8 + f"{op_list[i]} {instr_list[i]}" + "\n"
str_out += " " * 4 + "};\n"
str_out += " " * 4 + "assign rom [prog_leng:63] = '{(64-prog_leng){'0}};\n"
str_out += " " * 4 + "assign q = rom[addr];\n"
str_out += "endmodule"

with open(f"{sys.argv[1]}/imem.sv", "w") as f:
    f.write(str_out)
