#include "rand.h"

// A simple xorshift, meant to be fast not secure
static unsigned long state;
unsigned long rand() {
  unsigned long x = state;
  x ^= x << 13;
  x ^= x >> 7;
  x ^= x << 17;
  return state = x;
}
