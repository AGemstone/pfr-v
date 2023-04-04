#!/usr/bin/python
import subprocess as sp
import sys
if (len(sys.argv) < 2):
    print("Usage: ./export_opcode.py file.s")
    sys.exit(-1)
sp.run(f"aarch64-linux-gnu-as {sys.argv[1]} --warn --fatal-warnings".split(" "))
out = sp.run("aarch64-linux-gnu-objdump -D a.out".split(" "),capture_output=True).stdout
# for x in :
out_list = out.decode("utf8").split(("\n"))
out_list = filter(lambda x: x!="", out_list)
out_list = filter(lambda x: '\t' in x, out_list)
out_list = map(lambda x: x.split("\t")[1].strip(),out_list)
out_list = map(lambda x: f"'h{x},",out_list)
out_list = list(out_list)
out_list[-1] = out_list[-1][:-1]
print(" "*4 + f"localparam int prog_leng = {len(out_list)};")
print(" "*4 + "assign rom[0:prog_leng-1] = '{")
for x in out_list:
    print(" "*8 + x)
print(" "*4 + "};")
