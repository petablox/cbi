#include <stdio.h>

int main () {
  int i;
  int array[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0};
  int* begin = 0;
  int* end = array + 9;
  int k;
  scanf("%d", &k);

  if (k < 0)
    k = 0;

  if (k % 10 > 0)
    k = k % 10;

  for (begin = array + k; begin != end; begin++) {
    if (k % 2 == 0)
      printf("k is a multiple of 2 and the array element is %d\n", *begin);
    if (k % 3 == 0)
      printf("k is a multiple of 3 and the array element is %d\n", *begin);
    if (k % 5 == 0)
      printf("k is a multiple of 5 and the array element is %d\n", *begin);
    if (k % 7 == 0)
      printf("k is a multiple of 7 and the array element is %d\n", *begin);
  }
  return 0;
}
