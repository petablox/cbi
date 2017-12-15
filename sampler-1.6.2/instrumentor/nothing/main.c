#include <dlfcn.h>
#include <libgen.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include "library.h"


static void dlcheck()
{
  const char * const message = dlerror();
  if (message)
    {
      fputs(message, stderr);
      fputc('\n', stderr);
      exit(3);
    }
}


int main(int argc __attribute__((unused)), char *argv[])
{
  char path[PATH_MAX];
  snprintf(path, sizeof(path), "%s/libplugin.so", dirname(argv[0]));
  void * const plugin = dlopen(path, RTLD_LAZY);
  dlcheck();

  {
    void (* const function)() = (void (*)()) dlsym(plugin, "function");
    dlcheck();
    function();
  }
  
  libraryFunction();

  dlclose(plugin);
  dlcheck();
  return 0;
}
