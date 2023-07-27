# PassiFloRisc - V - A single cycle RV64IZicsr softcore.

A basic single cycle softcore written in SystemVerilog, tested on a DE0_NANO (https://www.terasic.com.tw/cgi-bin/page/archive.pl?No=593) with emulated fault injection using a Nios-II

## Features
* Single core, single cycle (pipeline in the near future)
* RV64IZicsr (No **FENCE** instruction)
* Synchronous exception support
* Basic mode switching without privileges 

## Overview
* *software/*: Contains a script that and a few test programs
* *tb/*: Contains testbenches for simulation
* *components/*: Contains the design files
* *de0_nano*: Contains the project files for the used board.

## Synthesis and fault injection using a DE0_NANO
As an example, a Quartus project is provided such that this project can be used or adapted more easily.
The scripts included are designed for Linux and rely on the PATH system variable to be properly set.
Requirements / dependencies:
* [RISC-V GCC](https://github.com/riscv-collab/riscv-gnu-toolchain) configured for RV64IA and LP64
* [Quartus Lite](https://www.intel.com/content/www/us/en/software-kit/660904/intel-quartus-prime-lite-edition-design-software-version-20-1-1-for-linux.html)
The steps for testing are as follows:
* Generate the memory initialization files using the *export_opcode_rv.py* script. 
* Use either the Quartus GUI or CLI to map, fit and assemble such that we generate an *.sof* file.
* Program the board.
* Change the current directory to *nios/software/hw/io* subdirectory of the Quartus project
* Setup the tests by editing the *fault_injection.py* script.
* Run the script and wait for it to finish. As a result we should have a data.dump file located in the same directory.
