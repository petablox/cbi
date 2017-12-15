#ifndef INCLUDE_sampler_once_threads_h
#define INCLUDE_sampler_once_threads_h

#include <pthread.h>


typedef pthread_once_t cbi_once_t;

#define CBI_ONCE_INIT PTHREAD_ONCE_INIT


static inline void
cbi_once(cbi_once_t *control, void (*routine)())
{
  pthread_once(control, routine);
}


#endif // !INCLUDE_sampler_once_threads_h
