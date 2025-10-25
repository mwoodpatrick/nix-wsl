#include "subdir/foo.h"
#include <stdio.h>

int fred2(char *arg) {
  printf("Hello %s\n", arg);

  return 0;
}

int main(int argc, char **argv) {
  if (argc != 1) {
    printf("%s takes no arguments.\n", argv[0]);
    return 1;
  }

  int fred = 0;
  printf("Hello World\n");
  // fred2(fred);
  fred2("fred");

  printf("got value: %d %d\n", fred, foo());
}
