#define _GNU_SOURCE 		/* for mremap */

#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include "countdown.h"
#include "lifetime.h"
#include "random.h"
#include "random-offline.h"
#include "random-offline-size.h"


#define MAP_SIZE (CBI_PRECOMPUTE_COUNT * sizeof(int))


const int *cbi_nextEventPrecomputed = 0;
CBI_THREAD_LOCAL unsigned cbi_nextEventSlot = 0;


static void failed(const char function[])
{
  fprintf(stderr, "%s failed: %s\n", function, strerror(errno));
  exit(2);
}


static void *checkedMmap(int prot, int fd)
{
  void * const mapping = mmap(0, MAP_SIZE, prot, MAP_PRIVATE, fd, 0);

  if (mapping == (void *) -1)
    failed("mmap");

  if (close(fd))
    failed("close");

  return mapping;
}


static int checkedOpen(const char filename[])
{
  const int fd = open(filename, O_RDONLY);

  if (fd == -1)
    {
      fprintf(stderr, "open of %s failed: %s\n", filename, strerror(errno));
      exit(2);
    }

  return fd;
}


void cbi_initialize_thread()
{
  cbi_nextEventCountdown = cbi_getNextEventCountdown();
}


static void finalize()
{
  if (cbi_nextEventPrecomputed)
    {
      munmap((void *) cbi_nextEventPrecomputed, MAP_SIZE);
      cbi_nextEventPrecomputed = 0;
    }
}


void cbi_initializeRandom()
{
  const char envar[] = "SAMPLER_EVENT_COUNTDOWNS";
  const char * const environ = getenv(envar);
  void *mapping;
  
  if (environ)
    {
      const int fd = checkedOpen(environ);
      mapping = checkedMmap(PROT_READ, fd);
      unsetenv(envar);
    }
  else
    {
      int fd;
      fprintf(stderr, "%s: no countdowns file named in $%s; using extreme sparsity\n",  __FUNCTION__, envar);
      fd = checkedOpen("/dev/zero");
      mapping = checkedMmap(PROT_READ | PROT_WRITE, fd);
      memset(mapping, -1, MAP_SIZE);
      mapping = mremap(mapping, MAP_SIZE, MAP_SIZE, PROT_READ);
      if (mapping == (void *) -1)
	failed("mremap");
    }

  atexit(finalize);
  cbi_nextEventPrecomputed = (const int *) mapping;
  cbi_initialize_thread();
}
