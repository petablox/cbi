#include <glib-object.h>
#include "g-object-unref.h"
#include "samples.h"
#include "tuple-4.h"


void cbi_gObjectUnrefReport(const cbi_UnitSignature signature,
			unsigned count, const cbi_Tuple4 tuples[])
{
  cbi_samplesBegin(signature, "g-object-unref");
  cbi_samplesDump4(count, tuples);
  cbi_samplesEnd();
}
