#ifndef INCLUDE_sampler_g_object_unref_unit_h
#define INCLUDE_sampler_g_object_unref_unit_h

#include "../unit-signature.h"
#include "g-object-unref.h"
#include "tuple-4.h"


#pragma cilnoremove("cbi_gObjectUnrefCounters")
static cbi_Tuple4 cbi_gObjectUnrefCounters[0];

#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_gObjectUnrefTimestampsFirst");
static cbi_Timestamp cbi_gObjectUnrefTimestampsFirst[sizeof(cbi_gObjectUnrefCounters) / sizeof(*cbi_gObjectUnrefCounters)];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_gObjectUnrefTimestampsLast");
static cbi_Timestamp cbi_gObjectUnrefTimestampsLast[sizeof(cbi_gObjectUnrefCounters) / sizeof(*cbi_gObjectUnrefCounters)];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_gObjectUnrefReporter")
#pragma sampler_exclude_function("cbi_gObjectUnrefReporter")
static void cbi_gObjectUnrefReporter() __attribute__((unused));
static void cbi_gObjectUnrefReporter()
{
  cbi_gObjectUnrefReport(cbi_unitSignature,
			 sizeof(cbi_gObjectUnrefCounters) / sizeof(*cbi_gObjectUnrefCounters),
			 cbi_gObjectUnrefCounters);
#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "g-object-unref", "first",
		       sizeof(cbi_gObjectUnrefTimestampsFirst) / sizeof(*cbi_gObjectUnrefTimestampsFirst),
		       cbi_gObjectUnrefTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "g-object-unref", "last",
		       sizeof(cbi_gObjectUnrefTimestampsLast) / sizeof(*cbi_gObjectUnrefTimestampsLast),
		       cbi_gObjectUnrefTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */
}


#pragma cilnoremove("cbi_gObjectUnrefClassify")


#endif /* !INCLUDE_sampler_g_object_unref_unit_h */
