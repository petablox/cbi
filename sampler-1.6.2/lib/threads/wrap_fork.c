#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include "random.h"
#include "report.h"


typeof(fork) __real_fork;
typeof(fork) __wrap_fork;

pid_t __wrap_fork(void)
{
  pid_t pid = __real_fork();
  if(pid == 0)
    {
      cbi_uninitializeReport();

      unsetenv("SAMPLER_SPARSITY");
      unsetenv("SAMPLER_EVENT_COUNTDOWNS");
      cbi_initializeRandom();
    }
  return pid;
}

