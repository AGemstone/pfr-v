transcript off
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/wideXOR.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/flopre.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/flopr.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/memory_stall.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/core_status.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/aludec_atomic.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/atom_alu.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/csr_dec.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/interruptDecode.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/exceptDecode.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/core.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/writeback.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/signext.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/regfile.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/memReadMask.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/memWriteMask.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/memory.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/datamemory.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/maindec.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/imem.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/flopre_init.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/fetch.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/execute.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/except_f.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/except_e.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/except_controller.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/decode.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/datapath.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/controller.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/branching.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/aludec.sv}
vlog -sv -work work +incdir+/mnt/hdd1/dev/risc/riscv/pfr-v/components {../components/alu.sv}
vlib coprocessor
vmap coprocessor coprocessor

vlog -sv -work work +incdir+../riscv/pfr-v/tb {../tb/processor_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L coprocessor -voptargs="+acc"  processor_tb

quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Signals}
add wave {/processor_tb/SIG_*}
add wave -noupdate -divider {Data Mem}
add wave -radix hexadecimal {/processor_tb/DM_*}
add wave -noupdate -divider {Coprocessor}
add wave -radix hexadecimal {/processor_tb/coprocessor*}
add wave -noupdate -divider {Program Status Registers}
add wave -radix hexadecimal {/processor_tb/opcode}
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
