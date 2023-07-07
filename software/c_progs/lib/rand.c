#include "rand.h"

// A simple xorshift, meant to be fast not secure
unsigned long state;
void rand_init(unsigned long seed) { state = seed; }
unsigned long rand() {
  unsigned long x = state;
  x ^= x << 13;
  x ^= x >> 7;
  x ^= x << 17;
  return state = x;
}
