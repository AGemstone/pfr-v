int kmain(void);
unsigned long long sum(unsigned long long n);

unsigned long long sum(unsigned long long n) {
  unsigned long long result = 0;
  unsigned long long i = 1;
  while (i < n) {
    result += i;
    i += 1;
  }
  return result;
}

int kmain(void) {
  // // sleep for a sec
  // __asm("li t5, 40000000");
  // __asm("sleep_loop: addi t5, t5, -1");
  // __asm("bne t5, zero, sleep_loop");
  unsigned long long result_1 = sum(0xbedead);
  __asm("li t6, 1;       \
         sd t6, 0(zero); \
        ");
  for (;;)
    ;
  return 0;
}
