#include <GLFW/glfw3.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
  struct passwd *p = getpwuid(getuid());
  if (p) {
    printf("Hello, %s\n", p->pw_name);
  }

  return EXIT_SUCCESS;
}
