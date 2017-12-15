#include <limits.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "countdown.h"
#include "lifetime.h"
#include "random.h"
#include "random-fixed.h"


int cbi_randomFixedCountdown;


void cbi_initialize_thread()
{
  cbi_nextEventCountdown = cbi_getNextEventCountdown();
}


void cbi_initializeRandom()
{
  const char * const environ = getenv("SAMPLER_SPARSITY");
  if (environ)
    {
      char *end;
      cbi_randomFixedCountdown = strtol(environ, &end, 0);
      if (*end != '\0')
	{
	  fprintf(stderr, "trailing garbage in $SAMPLER_SPARSITY: %s\n", end);
	  exit(2);
	}
      else if (cbi_randomFixedCountdown < 1)
	{
	  fputs("$SAMPLER_SPARSITY must be at least 1\n", stderr);
	  exit(2);
	}

      cbi_initialize_thread();
      unsetenv("SAMPLER_SPARSITY");
    }
  else
    {
      cbi_randomFixedCountdown = INT_MAX;
    }
}
