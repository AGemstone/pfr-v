typedef unsigned long size_t;
void *memcpy(void * dest, const void * src, unsigned int n) {
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

#define N 5
// void matrix_mul(const long * a, const long * b,
//                 long * mul) {
//   for (unsigned int i = 0; i < N; i++) {
//     for (unsigned int j = 0; j < N; j++) {
//       mul[i * N + j] = 0;
//       for (unsigned int k = 0; k < N; k++) {
//         mul[i * N + j] += a[i * N + k] * b[k * N + j];
//       }
//     }
//   }
// }

int main() {
  long a[N * N] = {424, 244, 510, 763, 695, 293, 599, 12,  95,
                   745, 179, 415, 404, 745, 61,  298, 973, 257,
                   769, 600, 426, 89,  281, 256, 634};
  long b[N * N] = {346, 149, 312, 852, 570, 435, 302, 89,  420,
                   260, 892, 123, 960, 213, 357, 334, 693, 263,
                   729, 889, 20,  445, 633, 736, 34};
  //int c[17] = {1,2,3,1,2,34,4,56,7,7,8,3,1,3,4,5,7};
// asm("nop;nop;nop;");
  // // Get the frame pointer
  // long *fp;
  // asm("nop;nop;nop");
  // asm volatile("mv %[fp], s0" : [fp] "=r"(fp));
  // long *a = fp;
  // long *b = fp + N * N;
  // *a++ = 424;
  // *a++ = 244;
  // *a++ = 510;
  // *a++ = 763;
  // *a++ = 695;
  // *a++ = 293;
  // *a++ = 599;
  // *a++ = 12;
  // *a++ = 95;
  // *a++ = 745;
  // *a++ = 179;
  // *a++ = 415;
  // *a++ = 404;
  // *a++ = 745;
  // *a++ = 61;
  // *a++ = 298;
  // *a++ = 973;
  // *a++ = 257;
  // *a++ = 769;
  // *a++ = 600;
  // *a++ = 426;
  // *a++ = 89;
  // *a++ = 281;
  // *a++ = 256;
  // *a++ = 634;

  // *b++ = 346;
  // *b++ = 149;
  // *b++ = 312;
  // *b++ = 852;
  // *b++ = 570;
  // *b++ = 435;
  // *b++ = 302;
  // *b++ = 89;
  // *b++ = 420;
  // *b++ = 260;
  // *b++ = 892;
  // *b++ = 123;
  // *b++ = 960;
  // *b++ = 213;
  // *b++ = 357;
  // *b++ = 334;
  // *b++ = 693;
  // *b++ = 263;
  // *b++ = 729;
  // *b++ = 889;
  // *b++ = 20;
  // *b++ = 445;
  // *b++ = 633;
  // *b++ = 736;
  // *b++ = 34;
  // a = fp;
  // b = fp + N * N;

  long pad = b[14];
  // long mul[N * N + N];
  // for (unsigned int i = 0; i < N * N; i++)
  //   mul[i] = 0;
  // matrix_mul(a, b, mul);
  // asm("nop;nop;nop;");

  /* Expected:
  [ 976506, 1037628, 1284208, 1640105, 1189127],
  [ 419277,  623391,  652817, 1121347,  436819],
  [ 852877,  745123,  715171, 1000861, 1018537],
  [1024453, 1169776, 1008340, 1719498, 1218630],
  [ 534947,  584453,  879243, 1113433,  615417]
  */
  return 0;
}