#define N 3
void matrix_mul(const long *a, const long *b, long *mul) {
  // ebreak();
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
  long a[N * N] = {1, 0, 0, 0, 1, 0, 0, 0, 1};
  long b[N * N] = {10, 0, 0, 4, 8, 6, 1, 7, 1};
  long mul[N * N + N];
  for (unsigned int i = 0; i < N * N + N; i++) {
    mul[i] = 0;
  }
  matrix_mul(a, b, mul);

  __asm("li t6, 1;       \
         sd t6, 0(zero); \
        ");

  for (;;)
    ;
  return 0;
}