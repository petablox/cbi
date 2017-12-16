#ifndef INCLUDE_libcountdown_random_fixed_h
#define INCLUDE_libcountdown_random_fixed_h


#ifdef CIL
#pragma cilnoremove("cbi_getNextEventCountdown")
#pragma sampler_exclude_function("cbi_getNextEventCountdown")
#endif


static inline int
cbi_getNextEventCountdown()
{
  extern int cbi_randomFixedCountdown;
  return cbi_randomFixedCountdown;
}


#endif /* !INCLUDE_libcountdown_random_fixed_h */
