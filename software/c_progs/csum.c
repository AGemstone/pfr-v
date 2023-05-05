long long main(void);
unsigned long long sum(unsigned long long n);

typedef unsigned long size_t;
void *memcpy(void *dest, const void *src, unsigned int n) {
  unsigned char *destCast = (unsigned char *)dest;
  unsigned char *srcCast = (unsigned char *)src;
  // No need for memory protection, just copy
  // Copy byte by byte
  while (n) {
    *destCast++ = *srcCast++;
    --n;
  }

  return dest;
}

unsigned long long sum(unsigned long long n) {
  unsigned long long result = 0;
  unsigned long long i = 1;
  while (i <= n) {
    result += i;
    i += 1;
  }
  return result;
}

long long main(void) {
  long a[] = {4294967303, 2, 3,   4,   5, 6, 7, 8, 9, 0,
              1,          2, 432, 123, 5, 1, 2, 5, 6};
  asm("nop;nop;nop;");
  long b = a[0];
  asm("nop;nop;nop;");
  unsigned long long result_1 = sum(10);

  return result_1;
}
