#include "samples.h"
#include "scalar-pairs.h"


void cbi_scalarPairsReport(const cbi_UnitSignature signature,
			   unsigned count, const cbi_Tuple3 tuples[])
{
  cbi_samplesBegin(signature, "scalar-pairs");
  cbi_samplesDump3(count, tuples);
  cbi_samplesEnd();
}
