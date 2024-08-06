transcript off
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/wideXOR.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/flopre.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/flopr.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/memory_stall.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/core_status.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/aludec_atomic.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/atom_alu.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/csr_dec.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/interruptDecode.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/exceptDecode.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/core.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/writeback.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/signext.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/regfile.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/memReadMask.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/memWriteMask.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/memory.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/datamemory.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/maindec.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/imem.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/flopre_init.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/fetch.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/execute.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/except_f.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/except_e.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/except_controller.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/decode.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/datapath.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/controller.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/branching.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/aludec.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/alu.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/forwarding.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/hazard.sv
vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/components/mux3.sv


vlib coprocessor
vmap coprocessor coprocessor

vlog -sv -work work /home/jojo/Documentos/Tesis/pfr-v/tb/processor_tb.sv

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L coprocessor -voptargs="+acc"  processor_tb

quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Signals}
add wave {/processor_tb/SIG_*}
add wave -noupdate -divider {Data Mem}
add wave -radix hexadecimal {/processor_tb/DM_*}
add wave -noupdate -divider {HDU signals}
add wave -noupdate -label {hazard} /processor_tb/dut/dp/hazard
add wave -noupdate -label {IF_ID_writeEnable} /processor_tb/dut/dp/IF_ID_writeEnable
add wave -noupdate -label {PCEnable} /processor_tb/dut/dp/PCEnable
add wave -noupdate -label {ControlEnable} /processor_tb/dut/dp/ControlEnable
add wave -noupdate -divider {Coprocessor}
add wave -radix hexadecimal {/processor_tb/coprocessor*}
add wave -noupdate -divider {Program Status Registers}
add wave -radix hexadecimal {/processor_tb/opcode}
add wave -radix hexadecimal {/processor_tb/dut/instrMem/q0}
add wave -noupdate -label {RV PC} -color {Cornflower Blue} -radix hexadecimal /processor_tb/dut/dp/FETCH/PC_out
add wave -noupdate -label {RV PC_Enable} /processor_tb/dut/dp/FETCH/PC_enable
add wave -noupdate -label {GPR ra / x01} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[1]}
add wave -noupdate -label {GPR sp / x02} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[2]}
add wave -noupdate -label {GPR fp / s0 / x08} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[8]}
add wave -noupdate -divider {Function Registers}
add wave -noupdate -label {GPR a0 / x10} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[10]}
add wave -noupdate -label {GPR a1 / x11} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[11]}
add wave -noupdate -label {GPR a2 / x12} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[12]}
add wave -noupdate -label {GPR a3 / x13} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[13]}
add wave -noupdate -label {GPR a4 / x14} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[14]}
add wave -noupdate -label {GPR a5 / x15} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[15]}
add wave -noupdate -label {GPR a6 / x16} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[16]}
add wave -noupdate -label {GPR a7 / x17} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[17]}
add wave -noupdate -divider {Other Registers}
add wave -noupdate -label {GPR zero / x0} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[0]}
add wave -noupdate -label {GPR ra / x1} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[1]}
add wave -noupdate -label {GPR sp / x2} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[2]}
add wave -noupdate -label {GPR gp / x3} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[3]}
add wave -noupdate -label {GPR tp / x4} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[4]}
add wave -noupdate -label {GPR t0 / x5} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[5]}
add wave -noupdate -label {GPR t1 / x6} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[6]}
add wave -noupdate -label {GPR t2 / x7} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[7]}
add wave -noupdate -label {GPR s0-fp / x8} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[8]}
add wave -noupdate -label {GPR s1 / x9} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[9]}
add wave -noupdate -label {GPR s2 / x18} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[18]}
add wave -noupdate -label {GPR s3 / x19} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[19]}
add wave -noupdate -label {GPR s4 / x20} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[20]}
add wave -noupdate -label {GPR s5 / x21} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[21]}
add wave -noupdate -label {GPR s6 / x22} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[22]}
add wave -noupdate -label {GPR s7 / x23} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[23]}
add wave -noupdate -label {GPR s8 / x24} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[24]}
add wave -noupdate -label {GPR s9 / x25} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[25]}
add wave -noupdate -label {GPR s10 / x26} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[26]}
add wave -noupdate -label {GPR s11 / x27} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[27]}
add wave -noupdate -label {GPR t3 / x28} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[28]}
add wave -noupdate -label {GPR t4 / x29} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[29]}
add wave -noupdate -label {GPR t5 / x30} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[30]}
add wave -noupdate -label {GPR t6 / x31} -radix hexadecimal {/processor_tb/dut/dp/DECODE/registers/ram[31]}

view structure
view signals
run -all

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 265
configure wave -valuecolwidth 125
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1207 ps}
