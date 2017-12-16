#ifndef INCLUDE_sampler_scalar_pairs_unit_h
#define INCLUDE_sampler_scalar_pairs_unit_h

#include "../unit-signature.h"
#include "scalar-pairs.h"
#include "tuple-3.h"


#pragma cilnoremove("cbi_scalarPairsCounters")
static cbi_Tuple3 cbi_scalarPairsCounters[0];

#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_scalarPairsTimestampsFirst");
static cbi_Timestamp cbi_scalarPairsTimestampsFirst[sizeof(cbi_scalarPairsCounters) / sizeof(*cbi_scalarPairsCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_scalarPairsTimestampsLast");
static cbi_Timestamp cbi_scalarPairsTimestampsLast[sizeof(cbi_scalarPairsCounters) / sizeof(*cbi_scalarPairsCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_scalarPairsReporter")
#pragma sampler_exclude_function("cbi_scalarPairsReporter")
static void cbi_scalarPairsReporter() __attribute__((unused));
static void cbi_scalarPairsReporter()
{
  cbi_scalarPairsReport(cbi_unitSignature,
			sizeof(cbi_scalarPairsCounters) / sizeof(*cbi_scalarPairsCounters),
			cbi_scalarPairsCounters);
#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "scalar-pairs", "first",
		       sizeof(cbi_scalarPairsTimestampsFirst) / sizeof(*cbi_scalarPairsTimestampsFirst),
		       cbi_scalarPairsTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "scalar-pairs", "last",
		       sizeof(cbi_scalarPairsTimestampsLast) / sizeof(*cbi_scalarPairsTimestampsLast),
		       cbi_scalarPairsTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_scalar_pairs_unit_h */
