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
