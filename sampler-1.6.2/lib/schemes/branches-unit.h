#ifndef INCLUDE_sampler_branches_unit_h
#define INCLUDE_sampler_branches_unit_h

#include "../unit-signature.h"
#include "branches.h"
#include "tuple-2.h"


#pragma cilnoremove("cbi_branchesCounters")
static cbi_Tuple2 cbi_branchesCounters[0];

#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_branchesTimestampsFirst");
static cbi_Timestamp cbi_branchesTimestampsFirst[sizeof(cbi_branchesCounters) / sizeof(*cbi_branchesCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_branchesTimestampsLast");
static cbi_Timestamp cbi_branchesTimestampsLast[sizeof(cbi_branchesCounters) / sizeof(*cbi_branchesCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_branchesReporter")
#pragma sampler_exclude_function("cbi_branchesReporter")
static void cbi_branchesReporter() __attribute__((unused));
static void cbi_branchesReporter()
{
  cbi_branchesReport(cbi_unitSignature,
		     sizeof(cbi_branchesCounters) / sizeof(*cbi_branchesCounters),
		     cbi_branchesCounters);
#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "branches", "first",
		       sizeof(cbi_branchesTimestampsFirst) / sizeof(*cbi_branchesTimestampsFirst),
		       cbi_branchesTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "branches", "last",
		       sizeof(cbi_branchesTimestampsLast) / sizeof(*cbi_branchesTimestampsLast),
		       cbi_branchesTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_branches_unit_h */
