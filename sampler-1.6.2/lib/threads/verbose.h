#ifndef INCLUDE_sampler_lib_threads_verbose_h
#define INCLUDE_sampler_lib_threads_verbose_h

#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>


void cbi_initializeVerbose(void);

#define VERBOSE(format, ...)						\
  do									\
    {									\
      extern int cbi_verbose;						\
      if (__builtin_expect(cbi_verbose != 0, 0))			\
	fprintf(stderr, "CBI: pid %d: " format, getpid(), ## __VA_ARGS__); \
    }									\
  while (0)


#endif /* !INCLUDE_sampler_lib_threads_verbose_h */
