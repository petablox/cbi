#ifndef INCLUDE_libcountdown_countdown_h
#define INCLUDE_libcountdown_countdown_h

#include "local.h"


extern CBI_THREAD_LOCAL int cbi_nextEventCountdown;


#ifdef CIL
#pragma cilnoremove("cbi_nextEventCountdown")
#endif


#endif /* !INCLUDE_libcountdown_countdown_h */
