#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "../lifetime.h"


typedef void * (*Starter)(void *);


typedef struct Closure
{
  Starter start;
  void *argument;
} Closure;


static void *starter(Closure *closure)
{
  const Starter start = closure->start;
  void * const argument = closure->argument;
  free(closure);

  cbi_initialize_thread();
  return start(argument);
}


typeof(pthread_create) __real_pthread_create;
typeof(pthread_create) __wrap_pthread_create;

int __wrap_pthread_create(pthread_t *thread,
			  const pthread_attr_t *attributes,
			  Starter start, void *argument)
{
  Closure * const closure = (Closure *) malloc(sizeof(Closure));
  if (!closure)
    {
      errno = ENOMEM;
      return -1;
    }

  closure->start = start;
  closure->argument = argument;
  return __real_pthread_create(thread, attributes, (Starter) starter, closure);
}
