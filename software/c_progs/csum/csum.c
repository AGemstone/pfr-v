unsigned long sum(unsigned long n) {
  unsigned long result = 0;
  unsigned long i = 1;
  while (i <= n) {
    result += i;
    i += 1;
  }
  return result;
}

int main(void) {
  unsigned long result_1 = sum(0xdc0de);
  return 0;
}
