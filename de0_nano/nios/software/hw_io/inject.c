#include "altera_avalon_pio_regs.h"
#include "nios2.h"
#include "sys/alt_irq.h"
#include "sys/alt_stdio.h"
#include "system.h"
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/* Injection setup */
#define INJECT_DELAY 8647
#define INJECT_ADDRESS 31
#define INJECT_DATA_LOW 0
#define INJECT_DATA_HIGH 134217728
#define PROGRAM_MAX_DURATION 10682

#define HAL_PLATFORM_RESET()                                                   \
  NIOS2_WRITE_STATUS(0);                                                       \
  NIOS2_WRITE_IENABLE(0);                                                      \
  ((void (*)(void))NIOS2_RESET_ADDR)()

int main() {
  IOWR_ALTERA_AVALON_PIO_DATA(IO_CONTROL_BASE, 0x1);

  // Injection: delay
  unsigned int watchdog = 0;
  IOWR_ALTERA_AVALON_PIO_DATA(IO_ADDR_BASE, 0x1000);
  IOWR_ALTERA_AVALON_PIO_DATA(IO_DATA_LOW_BASE, INJECT_DELAY);
  IOWR_ALTERA_AVALON_PIO_DATA(IO_CONTROL_BASE, 0x31);
  IOWR_ALTERA_AVALON_PIO_DATA(IO_CONTROL_BASE, 0x21);
  IOWR_ALTERA_AVALON_PIO_DATA(IO_DATA_HIGH_BASE, 0x0);
  IOWR_ALTERA_AVALON_PIO_DATA(IO_DATA_LOW_BASE, 0x0);
  IOWR_ALTERA_AVALON_PIO_DATA(IO_ADDR_BASE, 0x1000);
  usleep(500000);

  // Start Risc-V with the delay counter set
  IOWR_ALTERA_AVALON_PIO_DATA(IO_CONTROL_BASE, 0x20);

  // Wait until we stall
  while ((IORD_ALTERA_AVALON_PIO_DATA(IO_RISCV_FLAGS_BASE) & 0x1) != 0x1)
    ;

  // Disable delay counter and enable writes on registers
  IOWR_ALTERA_AVALON_PIO_DATA(IO_CONTROL_BASE, 0x2);
  // Injection: current PC
  IOWR_ALTERA_AVALON_PIO_DATA(IO_ADDR_BASE, 0x20);
  alt_printf("PC(injected):0x%x_%x,",
             IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_HIGH_BASE),
             IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_LOW_BASE));

  // Injection: register select
  IOWR_ALTERA_AVALON_PIO_DATA(IO_ADDR_BASE, INJECT_ADDRESS);
  alt_printf("current_val(injected):0x%x_%x,",
             IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_HIGH_BASE),
             IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_LOW_BASE));

  // Injection: bit select
  // Set and clear to avoid flipping twice
  IOWR_ALTERA_AVALON_PIO_DATA(IO_DATA_LOW_BASE, INJECT_DATA_LOW);
  IOWR_ALTERA_AVALON_PIO_DATA(IO_DATA_LOW_BASE, 0x0);
  IOWR_ALTERA_AVALON_PIO_DATA(IO_DATA_HIGH_BASE, INJECT_DATA_HIGH);
  IOWR_ALTERA_AVALON_PIO_DATA(IO_DATA_HIGH_BASE, 0x0);
  alt_printf("new_val(injected):0x%x_%x,",
             IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_HIGH_BASE),
             IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_LOW_BASE));

  IOWR_ALTERA_AVALON_PIO_DATA(IO_CONTROL_BASE, 0x0);

  // Wait for program to finish
  while ((IORD_ALTERA_AVALON_PIO_DATA(IO_RISCV_FLAGS_BASE) & 0x2) != 0x2 &&
         watchdog <= PROGRAM_MAX_DURATION)
    watchdog++;

  // Print results
  // Set Register Write with data=0 to disable PC and read registers
  IOWR_ALTERA_AVALON_PIO_DATA(IO_CONTROL_BASE, 0x2);
  // Read current PC
  IOWR_ALTERA_AVALON_PIO_DATA(IO_ADDR_BASE, 0x20);
  alt_printf("PC:0x%x_%x,", IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_HIGH_BASE),
             IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_LOW_BASE));
  // Read a0
  IOWR_ALTERA_AVALON_PIO_DATA(IO_ADDR_BASE, 0xa);
  if (watchdog > PROGRAM_MAX_DURATION) {
    alt_printf("result(reg a0):dnf,");
  } else {
    alt_printf("result(reg a0):0x%x_%x,",
               IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_HIGH_BASE),
               IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_LOW_BASE));
  }

  alt_printf("duration:0x%x", watchdog);
  
  // Memory dump
  alt_printf("||memdump||");
  IOWR_ALTERA_AVALON_PIO_DATA(IO_CONTROL_BASE, 0x8);
  for (unsigned int i = 0; i < 0x8000; i += 8) {
    IOWR_ALTERA_AVALON_PIO_DATA(IO_ADDR_BASE, i);
    IOWR_ALTERA_AVALON_PIO_DATA(IO_ADDR_BASE, i);
    alt_printf("0x%x:0x%x_0x%x,", i >> 3,
               IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_HIGH_BASE),
               IORD_ALTERA_AVALON_PIO_DATA(IO_DATA_LOW_BASE));
  }
  alt_printf("\n");

  // HAL_PLATFORM_RESET();

  // Event loop never exits.
  while (1)
    ;

  return 0;
}
