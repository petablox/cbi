#ifndef INCLUDE_sampler_bounds_unit_h
#define INCLUDE_sampler_bounds_unit_h

#include "../unit-signature.h"
#include "bounds.h"


#ifdef CBI_TIMESTAMP_FIRST
#pragma cilnoremove("cbi_boundsTimestampsFirst");
static cbi_Timestamp cbi_boundsTimestampsFirst[];
#endif /* CBI_TIMESTAMP_FIRST */

#ifdef CBI_TIMESTAMP_LAST
#pragma cilnoremove("cbi_boundsTimestampsLast");
static cbi_Timestamp cbi_boundsTimestampsLast[];
#endif /* CBI_TIMESTAMP_LAST */


#pragma cilnoremove("cbi_boundsReportDump")
#pragma sampler_exclude_function("cbi_boundsReportDump")
static void cbi_boundsReportDump();


#pragma cilnoremove("cbi_boundsReporter")
#pragma sampler_exclude_function("cbi_boundsReporter")
static void cbi_boundsReporter() __attribute__((unused));
static void cbi_boundsReporter()
{
  cbi_boundsReportBegin(cbi_unitSignature);
  cbi_boundsReportDump();
  cbi_boundsReportEnd();

#ifdef CBI_TIMESTAMP_FIRST
  cbi_timestampsReport(cbi_unitSignature, "bounds", "first",
		       sizeof(cbi_boundsTimestampsFirst) / sizeof(*cbi_boundsTimestampsFirst),
		       cbi_boundsTimestampsFirst);
#endif /* CBI_TIMESTAMP_FIRST */
#ifdef CBI_TIMESTAMP_LAST
  cbi_timestampsReport(cbi_unitSignature, "bounds", "last",
		       sizeof(cbi_boundsTimestampsLast) / sizeof(*cbi_boundsTimestampsLast),
		       cbi_boundsTimestampsLast);
#endif /* CBI_TIMESTAMP_LAST */
}


#endif /* !INCLUDE_sampler_bounds_unit_h */
