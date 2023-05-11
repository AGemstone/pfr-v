#include "compile_helpers.h"
#include <stdbool.h>

#define N 5
void matrix_mul(const long *a, const long *b, long *mul) {
  for (unsigned int i = 0; i < N; i++) {
    for (unsigned int j = 0; j < N; j++) {
      mul[i * N + j] = 0;
      for (unsigned int k = 0; k < N; k++) {
        mul[i * N + j] += a[i * N + k] * b[k * N + j];
      }
    }
  }
}

int main() {
  long a[N * N] = {424, 244, 510, 763, 695, 293, 599, 12,  95,
                   745, 179, 415, 404, 745, 61,  298, 973, 257,
                   769, 600, 426, 89,  281, 256, 634};
  long b[N * N] = {346, 149, 312, 852, 570, 435, 302, 89,  420,
                   260, 892, 123, 960, 213, 357, 334, 693, 263,
                   729, 889, 20,  445, 633, 736, 34};

  long mul[N * N];
  for (unsigned int i = 0; i < N * N; i++)
    mul[i] = 1;
  matrix_mul(a, b, mul);
  long pad = mul[0];
  /* Expected:
  [ 976506, 1037628, 1284208, 1640105, 1189127],
  [ 419277,  623391,  652817, 1121347,  436819],
  [ 852877,  745123,  715171, 1000861, 1018537],
  [1024453, 1169776, 1008340, 1719498, 1218630],
  [ 534947,  584453,  879243, 1113433,  615417]
  */

  return 0;
}