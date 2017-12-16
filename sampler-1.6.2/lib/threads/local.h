#ifndef INCLUDE_sensitive_local_h
#define INCLUDE_sensitive_local_h

#ifdef CBI_THREADS
#  define CBI_THREAD_LOCAL __thread
#else
#  define CBI_THREAD_LOCAL
#endif

#endif /* !INCLUDE_sensitive_local_h */
