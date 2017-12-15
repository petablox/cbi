#include <errno.h>
#include <pthread.h>


typeof(pthread_create) __wrap_pthread_create;

int __wrap_pthread_create(pthread_t *thread __attribute__((unused)),
			  const pthread_attr_t *attributes __attribute__((unused)),
			  void * (*start)(void *) __attribute__((unused)),
			  void *argument __attribute__((unused)))
{
  errno = ENOTSUP;
  return -1;
}
