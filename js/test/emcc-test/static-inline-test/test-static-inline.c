#include <stdio.h>
#include <string.h>
#include "test.h"

int main(int argc, char** argv) {
  printf("[INFO] Adding two numbers using a static inline func\n");
  int a = 2, b = 3, sum;
  sum = st_inln_add(a ,b);
  if (sum == a+b) {
    printf(">> Addition successful!\n");
  } else {
    printf("ERROR!\n");
  }
  return 0;
}
