#define _ISOC99_SOURCE 1
#include <math.h>
#include <stdlib.h>
#include "samples.h"
#include "float-kinds.h"


void
cbi_floatKindsReport(const cbi_UnitSignature signature,
		     unsigned count, const cbi_Tuple9 tuples[])
{
  cbi_samplesBegin(signature, "float-kinds");
  cbi_samplesDump9(count, tuples);
  cbi_samplesEnd();
}


enum Classification { NegativeInfinite,
		      NegativeNormal,
		      NegativeSubnormal,
		      NegativeZero,
		      NotANumber,
		      PositiveZero,
		      PositiveSubnormal,
		      PositiveNormal,
		      PositiveInfinite };


unsigned
cbi_floatKindsClassify(long double value)
{
  switch (fpclassify(value))
    {
    case FP_NAN:
      return NotANumber;
    case FP_INFINITE:
      return signbit(value) ? NegativeInfinite : PositiveInfinite;
    case FP_ZERO:
      return signbit(value) ? NegativeZero : PositiveZero;
    case FP_SUBNORMAL:
      return signbit(value) ? NegativeSubnormal : PositiveSubnormal;
    case FP_NORMAL:
      return signbit(value) ? NegativeNormal : PositiveNormal;
    default:
      abort();
    }
}
