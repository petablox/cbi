#ifndef INCLUDE_sampler_unit_h
#define INCLUDE_sampler_unit_h

#include "registry.h"


#pragma sampler_exclude_function("cbi_reporter")
static void cbi_reporter()
{
}


static struct cbi_Unit cbi_unit = { 0, 0, cbi_reporter };


#pragma sampler_exclude_function("cbi_constructor")
static void cbi_constructor() __attribute__((constructor));
static void cbi_constructor()
{
  cbi_registerUnit(&cbi_unit);
}


#pragma sampler_exclude_function("cbi_destructor")
static void cbi_destructor() __attribute__((destructor));
static void cbi_destructor()
{
  cbi_unregisterUnit(&cbi_unit);
}


#ifdef CBI_THREADS
#pragma cilnoremove("cbi_atomicIncrementCounter")
#pragma sampler_exclude_function("cbi_atomicIncrementCounter")
static inline void cbi_atomicIncrementCounter(unsigned *counter)
{
#if __i386__
  asm ("lock incl %0"
       : "+m" (*counter)
       :
       : "cc");
#else
#error "don't know how to atomically increment on this architecture"
#endif
}
#endif /* CBI_THREADS */


#endif /* !INCLUDE_sampler_unit_h */
