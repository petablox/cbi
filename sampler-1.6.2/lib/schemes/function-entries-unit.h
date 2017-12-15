#ifndef INCLUDE_sampler_function_entries_unit_h
#define INCLUDE_sampler_function_entries_unit_h

#include "../unit-signature.h"
#include "function-entries.h"
#include "tuple-1.h"


#pragma cilnoremove("cbi_functionEntriesCounters")
static cbi_Tuple1 cbi_functionEntriesCounters[0];

#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_functionEntriesTimestampsFirst");
static cbi_Timestamp cbi_functionEntriesTimestampsFirst[sizeof(cbi_functionEntriesCounters) / sizeof(*cbi_functionEntriesCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_functionEntriesTimestampsLast");
static cbi_Timestamp cbi_functionEntriesTimestampsLast[sizeof(cbi_functionEntriesCounters) / sizeof(*cbi_functionEntriesCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_functionEntriesReporter")
#pragma sampler_exclude_function("cbi_functionEntriesReporter")
static void cbi_functionEntriesReporter() __attribute__((unused));
static void cbi_functionEntriesReporter()
{
  cbi_functionEntriesReport(cbi_unitSignature,
			    sizeof(cbi_functionEntriesCounters) / sizeof(*cbi_functionEntriesCounters),
			    cbi_functionEntriesCounters);
#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "function-entries", "first",
		       sizeof(cbi_functionEntriesTimestampsFirst) / sizeof(*cbi_functionEntriesTimestampsFirst),
		       cbi_functionEntriesTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "function-entries", "last",
		       sizeof(cbi_functionEntriesTimestampsLast) / sizeof(*cbi_functionEntriesTimestampsLast),
		       cbi_functionEntriesTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_function_entries_unit_h */
