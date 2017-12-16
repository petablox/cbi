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
    void (* const function)(int) = (void (*)(int)) dlsym(plugin, "function");
    dlcheck();
    function(1);
  }
  
  libraryFunction(1);

  dlclose(plugin);
  dlcheck();
  return 0;
}
