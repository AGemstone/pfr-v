/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'NiosII' in SOPC Builder design 'coprocessor'
 * SOPC Builder design path: ../../coprocessor.sopcinfo
 *
 * Generated: Thu Jul 13 08:41:02 ART 2023
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00004820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0xf
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x00002020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0xf
#define ALT_CPU_NAME "NiosII"
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x00002000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00004820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0xf
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x00002020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0xf
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x00002000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_NIOS2_GEN2


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "Cyclone IV E"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_BASE 0x5050
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_BASE 0x5050
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_BASE 0x5050
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "coprocessor"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 4
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none


/*
 * io_addr configuration
 *
 */

#define ALT_MODULE_CLASS_io_addr altera_avalon_pio
#define IO_ADDR_BASE 0x5020
#define IO_ADDR_BIT_CLEARING_EDGE_REGISTER 0
#define IO_ADDR_BIT_MODIFYING_OUTPUT_REGISTER 0
#define IO_ADDR_CAPTURE 0
#define IO_ADDR_DATA_WIDTH 15
#define IO_ADDR_DO_TEST_BENCH_WIRING 0
#define IO_ADDR_DRIVEN_SIM_VALUE 0
#define IO_ADDR_EDGE_TYPE "NONE"
#define IO_ADDR_FREQ 50000000
#define IO_ADDR_HAS_IN 0
#define IO_ADDR_HAS_OUT 1
#define IO_ADDR_HAS_TRI 0
#define IO_ADDR_IRQ -1
#define IO_ADDR_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IO_ADDR_IRQ_TYPE "NONE"
#define IO_ADDR_NAME "/dev/io_addr"
#define IO_ADDR_RESET_VALUE 0
#define IO_ADDR_SPAN 16
#define IO_ADDR_TYPE "altera_avalon_pio"


/*
 * io_control configuration
 *
 */

#define ALT_MODULE_CLASS_io_control altera_avalon_pio
#define IO_CONTROL_BASE 0x5010
#define IO_CONTROL_BIT_CLEARING_EDGE_REGISTER 0
#define IO_CONTROL_BIT_MODIFYING_OUTPUT_REGISTER 0
#define IO_CONTROL_CAPTURE 0
#define IO_CONTROL_DATA_WIDTH 6
#define IO_CONTROL_DO_TEST_BENCH_WIRING 0
#define IO_CONTROL_DRIVEN_SIM_VALUE 0
#define IO_CONTROL_EDGE_TYPE "NONE"
#define IO_CONTROL_FREQ 50000000
#define IO_CONTROL_HAS_IN 0
#define IO_CONTROL_HAS_OUT 1
#define IO_CONTROL_HAS_TRI 0
#define IO_CONTROL_IRQ -1
#define IO_CONTROL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IO_CONTROL_IRQ_TYPE "NONE"
#define IO_CONTROL_NAME "/dev/io_control"
#define IO_CONTROL_RESET_VALUE 1
#define IO_CONTROL_SPAN 16
#define IO_CONTROL_TYPE "altera_avalon_pio"


/*
 * io_data_high configuration
 *
 */

#define ALT_MODULE_CLASS_io_data_high altera_avalon_pio
#define IO_DATA_HIGH_BASE 0x5030
#define IO_DATA_HIGH_BIT_CLEARING_EDGE_REGISTER 0
#define IO_DATA_HIGH_BIT_MODIFYING_OUTPUT_REGISTER 0
#define IO_DATA_HIGH_CAPTURE 0
#define IO_DATA_HIGH_DATA_WIDTH 32
#define IO_DATA_HIGH_DO_TEST_BENCH_WIRING 0
#define IO_DATA_HIGH_DRIVEN_SIM_VALUE 0
#define IO_DATA_HIGH_EDGE_TYPE "NONE"
#define IO_DATA_HIGH_FREQ 50000000
#define IO_DATA_HIGH_HAS_IN 1
#define IO_DATA_HIGH_HAS_OUT 1
#define IO_DATA_HIGH_HAS_TRI 0
#define IO_DATA_HIGH_IRQ -1
#define IO_DATA_HIGH_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IO_DATA_HIGH_IRQ_TYPE "NONE"
#define IO_DATA_HIGH_NAME "/dev/io_data_high"
#define IO_DATA_HIGH_RESET_VALUE 0
#define IO_DATA_HIGH_SPAN 16
#define IO_DATA_HIGH_TYPE "altera_avalon_pio"


/*
 * io_data_low configuration
 *
 */

#define ALT_MODULE_CLASS_io_data_low altera_avalon_pio
#define IO_DATA_LOW_BASE 0x5040
#define IO_DATA_LOW_BIT_CLEARING_EDGE_REGISTER 0
#define IO_DATA_LOW_BIT_MODIFYING_OUTPUT_REGISTER 0
#define IO_DATA_LOW_CAPTURE 0
#define IO_DATA_LOW_DATA_WIDTH 32
#define IO_DATA_LOW_DO_TEST_BENCH_WIRING 0
#define IO_DATA_LOW_DRIVEN_SIM_VALUE 0
#define IO_DATA_LOW_EDGE_TYPE "NONE"
#define IO_DATA_LOW_FREQ 50000000
#define IO_DATA_LOW_HAS_IN 1
#define IO_DATA_LOW_HAS_OUT 1
#define IO_DATA_LOW_HAS_TRI 0
#define IO_DATA_LOW_IRQ -1
#define IO_DATA_LOW_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IO_DATA_LOW_IRQ_TYPE "NONE"
#define IO_DATA_LOW_NAME "/dev/io_data_low"
#define IO_DATA_LOW_RESET_VALUE 0
#define IO_DATA_LOW_SPAN 16
#define IO_DATA_LOW_TYPE "altera_avalon_pio"


/*
 * io_riscv_flags configuration
 *
 */

#define ALT_MODULE_CLASS_io_riscv_flags altera_avalon_pio
#define IO_RISCV_FLAGS_BASE 0x5000
#define IO_RISCV_FLAGS_BIT_CLEARING_EDGE_REGISTER 0
#define IO_RISCV_FLAGS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define IO_RISCV_FLAGS_CAPTURE 0
#define IO_RISCV_FLAGS_DATA_WIDTH 2
#define IO_RISCV_FLAGS_DO_TEST_BENCH_WIRING 0
#define IO_RISCV_FLAGS_DRIVEN_SIM_VALUE 0
#define IO_RISCV_FLAGS_EDGE_TYPE "NONE"
#define IO_RISCV_FLAGS_FREQ 50000000
#define IO_RISCV_FLAGS_HAS_IN 1
#define IO_RISCV_FLAGS_HAS_OUT 0
#define IO_RISCV_FLAGS_HAS_TRI 0
#define IO_RISCV_FLAGS_IRQ -1
#define IO_RISCV_FLAGS_IRQ_INTERRUPT_CONTROLLER_ID -1
#define IO_RISCV_FLAGS_IRQ_TYPE "NONE"
#define IO_RISCV_FLAGS_NAME "/dev/io_riscv_flags"
#define IO_RISCV_FLAGS_RESET_VALUE 0
#define IO_RISCV_FLAGS_SPAN 16
#define IO_RISCV_FLAGS_TYPE "altera_avalon_pio"


/*
 * jtag_uart configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart
#define JTAG_UART_BASE 0x5050
#define JTAG_UART_IRQ 0
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_SPAN 8
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8


/*
 * memory configuration
 *
 */

#define ALT_MODULE_CLASS_memory altera_avalon_onchip_memory2
#define MEMORY_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define MEMORY_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define MEMORY_BASE 0x2000
#define MEMORY_CONTENTS_INFO ""
#define MEMORY_DUAL_PORT 0
#define MEMORY_GUI_RAM_BLOCK_TYPE "AUTO"
#define MEMORY_INIT_CONTENTS_FILE "coprocessor_memory"
#define MEMORY_INIT_MEM_CONTENT 0
#define MEMORY_INSTANCE_ID "NONE"
#define MEMORY_IRQ -1
#define MEMORY_IRQ_INTERRUPT_CONTROLLER_ID -1
#define MEMORY_NAME "/dev/memory"
#define MEMORY_NON_DEFAULT_INIT_FILE_ENABLED 0
#define MEMORY_RAM_BLOCK_TYPE "AUTO"
#define MEMORY_READ_DURING_WRITE_MODE "DONT_CARE"
#define MEMORY_SINGLE_CLOCK_OP 0
#define MEMORY_SIZE_MULTIPLE 1
#define MEMORY_SIZE_VALUE 6144
#define MEMORY_SPAN 6144
#define MEMORY_TYPE "altera_avalon_onchip_memory2"
#define MEMORY_WRITABLE 1

#endif /* __SYSTEM_H_ */
