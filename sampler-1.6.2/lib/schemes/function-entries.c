#include "function-entries.h"
#include "samples.h"
#include "tuple-2.h"


void cbi_functionEntriesReport(const cbi_UnitSignature signature,
			       unsigned count, const cbi_Tuple1 counts[])
{
  cbi_samplesBegin(signature, "function-entries");
  cbi_samplesDump1(count, counts);
  cbi_samplesEnd();
}
