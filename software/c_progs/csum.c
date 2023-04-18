// int kmain(void);
unsigned long long sum(unsigned long long n);

unsigned long long sum(unsigned long long n) {
  unsigned long long result = 0;
  unsigned long long i = 1;
  while (i <= n) {
    result += i;
    i += 1;
  }
  return result;
}

int main(void) {
  unsigned long long result_1 = sum(0xbedead);
  __asm("li t6, 1;       \
         sd t6, 0(zero); \
        ");
  for (;;)
    ;
  return 0;
}
