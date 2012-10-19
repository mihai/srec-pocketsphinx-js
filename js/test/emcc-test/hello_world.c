#include <stdio.h>

int main(int argc, char** argv) {
  if (argc < 2 ) {
    printf("Usage: %s file\n", argv[0]);
    return 1;
  }

  FILE *fp;
  printf("Hello world, opening file %s\n", argv[1]);
  fp = fopen(argv[1], "r");
  
  if (fp == NULL) {
    printf("ERROR: Couldn't open file!\n");
    return 1;
  } else {
    printf("File opened successfully!\n");
  }

  return 0;
}
