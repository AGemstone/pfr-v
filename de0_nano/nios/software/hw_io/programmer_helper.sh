#!/bin/bash
source ~/.bashrc
CWD=$(pwd)
~/intelFPGA_lite/20.1/quartus/bin/quartus_pgm -m jtag -o "p;DE0_NANO.sof"