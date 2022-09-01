#!/usr/bin/python
import subprocess as sp
import sys
if (len(sys.argv) < 3):
    print("Usage: ./export_opcode.py file.s <output_dir>")
    sys.exit(-1)
sp.run(f"riscv64-linux-gnu-as {sys.argv[1]} --warn --fatal-warnings".split(" "))
out = sp.run("riscv64-linux-gnu-objdump -d a.out".split(" "),capture_output=True).stdout
# for x in :
out_list = out.decode("utf8").split(("\n"))
out_list = filter(lambda x: x!="", out_list)
out_list = filter(lambda x: '\t' in x, out_list)
out_list = map(lambda x: x.split("\t")[1].strip(),out_list)
out_list = map(lambda x: f"'h{x},",out_list)
out_list = list(out_list)
out_list[-1] = out_list[-1][:-1]

str_out = "module imem #(parameter N = 32)(\n"
str_out +=" " * 4 + "input logic[5:0] addr,\n"
str_out +=" " * 4 + "output logic[N-1:0] q\n"
str_out +=");\n"
str_out +=" " * 4 + "logic [N - 1:0] rom [0 : 63];\n"
str_out += " " *4 + f"localparam int prog_leng = {len(out_list)};\n"
str_out += " " *4 + "assign rom[0:prog_leng-1] = '{\n"
for x in out_list:
    str_out += " " * 8 + x + "\n"
str_out += " " * 4 + "};\n"
str_out += " " * 4 + "assign rom [prog_leng:63] = '{(64-prog_leng){'0}};\n"
str_out += " " * 4 + "assign q = rom[addr];\n"    
str_out += "endmodule"

with open(f"{sys.argv[2]}/imem.sv",'w') as f:
   f.write(str_out)

