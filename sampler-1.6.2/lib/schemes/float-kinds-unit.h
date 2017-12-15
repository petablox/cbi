#ifndef INCLUDE_sampler_float_kinds_unit_h
#define INCLUDE_sampler_float_kinds_unit_h

#include "../unit-signature.h"
#include "float-kinds.h"
#include "tuple-3.h"


#pragma cilnoremove("cbi_floatKindsCounters")
static cbi_Tuple9 cbi_floatKindsCounters[0];

#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_floatKindsTimestampsFirst");
static cbi_Timestamp cbi_floatKindsTimestampsFirst[sizeof(cbi_floatKindsCounters) / sizeof(*cbi_floatKindsCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_floatKindsTimestampsLast");
static cbi_Timestamp cbi_floatKindsTimestampsLast[sizeof(cbi_floatKindsCounters) / sizeof(*cbi_floatKindsCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_floatKindsReporter")
#pragma sampler_exclude_function("cbi_floatKindsReporter")
static void cbi_floatKindsReporter() __attribute__((unused));
static void cbi_floatKindsReporter()
{
  cbi_floatKindsReport(cbi_unitSignature,
		       sizeof(cbi_floatKindsCounters) / sizeof(*cbi_floatKindsCounters),
		       cbi_floatKindsCounters);
#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "float-kinds", "first",
		       sizeof(cbi_floatKindsTimestampsFirst) / sizeof(*cbi_floatKindsTimestampsFirst),
		       cbi_floatKindsTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "float-kinds", "last",
		       sizeof(cbi_floatKindsTimestampsLast) / sizeof(*cbi_floatKindsTimestampsLast),
		       cbi_floatKindsTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */
}


#pragma cilnoremove("cbi_floatKindsClassify")


#endif /* !INCLUDE_sampler_float_kinds_unit_h */
