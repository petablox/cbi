#ifndef INCLUDE_sampler_returns_unit_h
#define INCLUDE_sampler_returns_unit_h

#include "../unit-signature.h"
#include "returns.h"
#include "tuple-3.h"


#pragma cilnoremove("cbi_returnsCounters")
static cbi_Tuple3 cbi_returnsCounters[0];

#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_returnsTimestampsFirst");
static cbi_Timestamp cbi_returnsTimestampsFirst[sizeof(cbi_returnsCounters) / sizeof(*cbi_returnsCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_returnsTimestampsLast");
static cbi_Timestamp cbi_returnsTimestampsLast[sizeof(cbi_returnsCounters) / sizeof(*cbi_returnsCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_returnsReporter")
#pragma sampler_exclude_function("cbi_returnsReporter")
static void cbi_returnsReporter() __attribute__((unused));
static void cbi_returnsReporter()
{
  cbi_returnsReport(cbi_unitSignature,
		    sizeof(cbi_returnsCounters) / sizeof(*cbi_returnsCounters),
		    cbi_returnsCounters);
#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "returns", "first",
		       sizeof(cbi_returnsTimestampsFirst) / sizeof(*cbi_returnsTimestampsFirst),
		       cbi_returnsTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "returns", "last",
		       sizeof(cbi_returnsTimestampsLast) / sizeof(*cbi_returnsTimestampsLast),
		       cbi_returnsTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_returns_unit_h */
