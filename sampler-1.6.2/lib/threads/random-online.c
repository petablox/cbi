#include <assert.h>
#include <limits.h>
#include <math.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include "countdown.h"
#include "lifetime.h"
#include "random-online.h"
#include "verbose.h"


static double densityScale;
static unsigned short seed[3];
static FILE *entropy;

static CBI_THREAD_LOCAL int sampling;
static CBI_THREAD_LOCAL struct drand48_data randomBuffer;


void cbi_initialize_thread()
{
  if (entropy)
    {
      unsigned short seed[3];
      if (fread(seed, sizeof(seed), 1, entropy) == 1)
	sampling = seed48_r(seed, &randomBuffer) >= 0;
    }
  else
    sampling = seed48_r(seed, &randomBuffer) >= 0;

  cbi_nextEventCountdown = cbi_getNextEventCountdown();
  VERBOSE("initialized thread; next event countdown *%p == %d\n", &cbi_nextEventCountdown, cbi_nextEventCountdown);
}


static void finalize()
{
  if (entropy)
    {
      fclose(entropy);
      entropy = 0;
    }
}


void cbi_initializeRandom()
{
  const char * const environ = getenv("SAMPLER_SPARSITY");
  if (environ)
    {
      char *end;
      const double sparsity = strtod(environ, &end);
      if (*end != '\0')
	{
	  fprintf(stderr, "trailing garbage in $SAMPLER_SPARSITY: %s\n", end);
	  exit(2);
	}
      else if (sparsity < 1)
	{
	  fputs("$SAMPLER_SPARSITY must be at least 1\n", stderr);
	  exit(2);
	}
      else
	{
	  const char * const environ = getenv("SAMPLER_SEED");
	  if (environ)
	    {
	      char *end;
	      union {
		uint64_t all;
		uint16_t triple[3];
	      } convert;

	      convert.all = strtoull(environ, &end, 0);
	      if (*end != '\0')
		{
		  fprintf(stderr, "trailing garbage in $SAMPLER_SEED: %s\n", end);
		  exit(2);
		}

	      seed[0] = convert.triple[0];
	      seed[1] = convert.triple[1];
	      seed[2] = convert.triple[2];
	    }
	  else
	    {
	      atexit(finalize);
	      entropy = fopen("/dev/urandom", "r");
	    }

	  densityScale = 1 / log(1 - 1 / sparsity);
	  cbi_initialize_thread();
	}

      unsetenv("SAMPLER_SPARSITY");
      unsetenv("SAMPLER_SEED");
      VERBOSE("initialized online random countdown generator\n");
    }
  else
    {
      sampling = 0;
    }
}


/**********************************************************************/


int cbi_getNextEventCountdown()
{
  if (__builtin_expect(sampling, 1))
    while (1)
      {
	double real;
	const int error = drand48_r(&randomBuffer, &real);
	if (__builtin_expect(error < 0, 0))
	  break;
	if (__builtin_expect(real != 0., 1))
	  {
	    const int next = log(real) * densityScale + 1;
	    VERBOSE("got next event countdown == %d\n", next);
	    return next;
	  }
      }

  VERBOSE("not sampling; next event countdown == INT_MAX\n");
  return INT_MAX;
}
