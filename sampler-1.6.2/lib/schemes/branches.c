#include "branches.h"
#include "samples.h"


void cbi_branchesReport(const cbi_UnitSignature signature,
			unsigned count, const cbi_Tuple2 sites[])
{
  cbi_samplesBegin(signature, "branches");
  cbi_samplesDump2(count, sites);
  cbi_samplesEnd();
}
