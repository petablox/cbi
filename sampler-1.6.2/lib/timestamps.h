#ifndef INCLUDE_sampler_timestamps_h
#define INCLUDE_sampler_timestamps_h

#include "signature.h"


typedef unsigned long long cbi_Timestamp;


void cbi_timestampsSetFirst(unsigned, cbi_Timestamp []);
void cbi_timestampsSetLast(unsigned, cbi_Timestamp []);
void cbi_timestampsSetBoth(unsigned, cbi_Timestamp [], cbi_Timestamp []);

void cbi_timestampsReport(const cbi_UnitSignature,
			  const char [], const char when[],
			  unsigned, const cbi_Timestamp []);


#ifdef CIL
#pragma cilnoremove("cbi_timestampsSetFirst")
#pragma cilnoremove("cbi_timestampsSetLast")
#pragma cilnoremove("cbi_timestampsSetBoth")
#pragma sampler_assume_weightless("cbi_timestampsSetFirst")
#pragma sampler_assume_weightless("cbi_timestampsSetLast")
#pragma sampler_assume_weightless("cbi_timestampsSetBoth")
#endif

#endif /* !INCLUDE_sampler_timestamps_h */
