#include <stdio.h>

int fred2(char *arg)
{
  printf("Hello %s", arg);

  return 0;
}

int main(int argc, char **argv) {
  int fred = 0;
  printf("Hello World");
  fred2(fred);
}

