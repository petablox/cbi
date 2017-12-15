#define _GNU_SOURCE    /* for PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP */

#include <pthread.h>
#include "lock.h"
#include "../timestamps.h"


static cbi_Timestamp nextTimestamp;

static pthread_mutex_t clockLock __attribute__((unused)) = PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP;


void cbi_timestampsSetFirst(unsigned site, cbi_Timestamp first[])
{
  CBI_CRITICAL_REGION(clockLock, {
    ++nextTimestamp;
    if (!first[site]) first[site] = nextTimestamp;
  });
}


void cbi_timestampsSetLast(unsigned site, cbi_Timestamp last[])
{
  CBI_CRITICAL_REGION(clockLock, {
    ++nextTimestamp;
    last[site] = nextTimestamp;
  });
}


void cbi_timestampsSetBoth(unsigned site, cbi_Timestamp first[], cbi_Timestamp last[])
{
  CBI_CRITICAL_REGION(clockLock, {
    ++nextTimestamp;
    if (!first[site]) first[site] = nextTimestamp;
    last[site] = nextTimestamp;
  });
}
