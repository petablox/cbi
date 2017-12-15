#include <stdio.h>
#include "../report.h"
#include "tuple-3.h"


void cbi_samplesDump3(unsigned count, const cbi_Tuple3 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(cbi_reportFile, "%u\t%u\t%u\n",
	    tuples[scan][0],
	    tuples[scan][1],
	    tuples[scan][2]);
}
