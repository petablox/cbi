#include <stdlib.h>
#include "verbose.h"


int cbi_verbose;


void
cbi_initializeVerbose()
{
  cbi_verbose = !!getenv("SAMPLER_VERBOSE");
}
