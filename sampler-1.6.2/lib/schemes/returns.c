#include "returns.h"
#include "samples.h"


void cbi_returnsReport(const cbi_UnitSignature signature,
		       unsigned count, const cbi_Tuple3 tuples[])
{
  cbi_samplesBegin(signature, "returns");
  cbi_samplesDump3(count, tuples);
  cbi_samplesEnd();
}
