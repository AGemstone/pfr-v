# A script for automating fault injection 

import numpy as np
import random
import subprocess as sp
import os
import sys
import traceback
import parse_helpers
import time
import datetime


def generate_fault_injector(register, data_inject, delay, duration):
    with open("hello_world_small.c", "r") as f:
        current = np.array(f.read().split("\n"))
        index = parse_helpers.index_where_str_in(current,
                                                 'Injection setup') + 1
        data_low = data_inject & 0xffffffff
        data_high = data_inject >> 32
        prog_cycles = duration
        current[index:index + 5] = [f"#define INJECT_DELAY {delay}",
                                    f"#define INJECT_ADDRESS {register}",
                                    f"#define INJECT_DATA_LOW {data_low}",
                                    f"#define INJECT_DATA_HIGH {data_high}",
                                    f"#define PROGRAM_MAX_DURATION {prog_cycles}"]

    with open("inject.c", "w") as f:
        f.write("\n".join(current))
    return current[index:index+3]


def download_elf():
    cwd = os.getcwd()
    os.chdir("/mnt/hdd1/dev/risc/de0_nano/nios/software/henlo_io")
    sp.call(["make", "download-elf"], stdout=sp.PIPE)
    os.chdir(cwd)


def program_fpga():
    ret_val = sp.call("./programmer_helper.sh", stdout=sp.PIPE)
    if ret_val != 0:
        print("FPGA programming error!")
        sys.exit(-1)

def parse_memdump(dump, data_radix="h"):
    new_dump = []
    if data_radix == "h":
        for line in dump:
            word, data = line.split(":")
            data = data.split("_")
            parsed_line = f"{int(word,16):4}:0x{int(data[0],16):08x}{int(data[1],16):08x}"
            new_dump.append(parsed_line)
    else:
        f"0x{v:064b}"
    return new_dump


def file_write_line(file_object, line, **kwargs):
    reg = kwargs["reg"]
    flipped_bit = kwargs["flipped_bit"]
    delay = kwargs["delay"]
    register_results, memdump = line.split("||memdump||")
    memdump = memdump.split(",")[:-1]
    output = f"{register_results},reg:{reg},flipped:{flipped_bit},delay:{delay}"
    memdump = "\n".join(parse_memdump(memdump))

    file_object.write(f"{output}\nmemdump:\n{memdump}\n\n")


def run_test(register=None, max_duration=None):
    program_fpga()
    duration = None
    max_delay = max_duration
    if register is None:
        register = random.randint(0, 32)
    if max_duration is None:
        max_duration = 0xffffffff
        max_delay = 12
    cmd = ['stdbuf', '-i0', '-o0', '-e0', 'nios2-terminal']
    with sp.Popen(cmd, stdout=sp.PIPE, stdin=sp.PIPE) as proc:
        # Parse first lines of nios2-terminal
        line = proc.stdout.readline().decode("utf-8")
        while line != "\n":
            line = proc.stdout.readline().decode("utf-8")
        # Run injector
        try:
            # Generate random values
            flipped_bit = random.randint(0, 63)
            data_flip = 1 << flipped_bit
            delay = random.randint(12, max_delay)
            generate_fault_injector(register, data_flip, delay, max_duration)
            download_elf()
            line = proc.stdout.readline().decode("utf-8")
            duration = int(line.split(",")[5].split(":")[1].split("||")[0], 16)
            file_write_line(data_dump, line, reg=register,
                            flipped_bit=flipped_bit, delay=delay)
        except:
            traceback.print_exc()
            sys.exit(-1)
        finally:
            proc.terminate()

    return duration


RUN_COUNT = 100
registers = range(1, 32)
# registers.append(0)
# registers = [1, 2, 3, 8, 10, 11, 12, 13, 14, 15]
# registers = [1,12,0,15,2]
start_time = datetime.datetime.now()

with open("data.dump", "w") as data_dump:

    # Generate a clean run without faults
    max_duration = run_test(0)

    for reg in registers:
        for i in range(RUN_COUNT):
            print(i, reg)
            # Extend duration in case an operation takes longer
            run_test(reg, max_duration*2)


# run_avg = (end_ns - start_ns) / (RUN_COUNT * len(critical_registers))
print("Done!")
print(f"Started at {start_time}")
print(f"Finished at {datetime.datetime.now()}")
# print(f"Run avg. (ns) {run_avg}")
