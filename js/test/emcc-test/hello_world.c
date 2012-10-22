#include <stdio.h>
#include <string.h>
#define BIO_HDRARG_MAX  32

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

  // sphinxbase/bio.c test --------------------------------
  int i, l, lineno;
  char line[16384], word[4096];

  lineno = 0;
    if (fgets(line, sizeof(line), fp) == NULL){
        printf("Premature EOF, line %d\n", lineno);
        goto error_out;
    }
  lineno++;

  if ((line[0] == 's') && (line[1] == '3') && (line[2] == '\n')) {
      for (i = 0;;) {
          if (fgets(line, sizeof(line), fp) == NULL) {
              printf("Premature EOF, line %d\n", lineno);
              goto error_out;
          }
          lineno++;

          if (sscanf(line, "%s%n", word, &l) != 1) {
              printf("Header format error, line %d\n", lineno);
              goto error_out;
          }
          printf("[DEBUG] word 1: %s, l: %d\n", word, l);

          if (strcmp(word, "endhdr") == 0)
              break;
          if (word[0] == '#') /* Skip comments */
              continue;

          if (i >= BIO_HDRARG_MAX) {
              printf("Max arg-value limit(%d) exceeded; increase BIO_HDRARG_MAX\n",
                   BIO_HDRARG_MAX);
              goto error_out;
          }

          //(*argname)[i] = ckd_salloc(word);
          if (sscanf(line + l, "%s", word) != 1) {      /* Multi-word values not allowed */
              printf("Header format error, line %d\n", lineno);
              goto error_out;
          }

          printf("[DEBUG] word 2: %s\n", word);
          //(*argval)[i] = ckd_salloc(word);
          i++;
          printf("Iter: %d, lineno: %d\n", i, lineno);
      }
  }

  printf(">> Success!\n");

  return 0;
  error_out:
    printf("ERROR!\n");
    return 1;
}
