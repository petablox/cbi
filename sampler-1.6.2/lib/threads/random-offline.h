#ifndef INCLUDE_sampler_random_offline_h
#define INCLUDE_sampler_random_offline_h

#include "local.h"
#include "random-offline-size.h"


#ifdef CIL
#pragma cilnoremove("cbi_getNextEventCountdown")
#pragma sampler_exclude_function("cbi_getNextEventCountdown")
#endif


static inline int cbi_getNextEventCountdown()
{
  extern const int *cbi_nextEventPrecomputed;
  extern CBI_THREAD_LOCAL unsigned cbi_nextEventSlot;

  unsigned slot = cbi_nextEventSlot;
  const int result = cbi_nextEventPrecomputed[slot];
  slot = (slot + 1) % CBI_PRECOMPUTE_COUNT;
  cbi_nextEventSlot = slot;
  return result;
}


#endif /* !INCLUDE_sampler_random_offline_h */
