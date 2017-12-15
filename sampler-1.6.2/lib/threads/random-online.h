#ifndef INCLUDE_libcountdown_random_online_h
#define INCLUDE_libcountdown_random_online_h


#ifdef CIL
#pragma cilnoremove("cbi_getNextEventCountdown")
#pragma sampler_assume_weightless("cbi_getNextEventCountdown")
#endif


int cbi_getNextEventCountdown(void);


#endif /* !INCLUDE_libcountdown_random_online_h */
