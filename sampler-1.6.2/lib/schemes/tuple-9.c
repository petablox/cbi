#include <stdio.h>
#include "../report.h"
#include "tuple-9.h"


void cbi_samplesDump9(unsigned count, const cbi_Tuple9 tuples[])
{
  unsigned scan;

  for (scan = 0; scan < count; ++scan)
    fprintf(cbi_reportFile,
	    "%u\t%u\t%u\t"
	    "%u\t%u\t%u\t"
	    "%u\t%u\t%u\n",
	    tuples[scan][0], tuples[scan][1], tuples[scan][2],
	    tuples[scan][3], tuples[scan][4], tuples[scan][5],
	    tuples[scan][6], tuples[scan][7], tuples[scan][8]);
}
