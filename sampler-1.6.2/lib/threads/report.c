#define _GNU_SOURCE    /* for PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP */

#include <errno.h>
#include <execinfo.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include "../registry.h"
#include "../report.h"
#include "lock.h"
#include "verbose.h"


FILE *cbi_reportFile;

static pthread_mutex_t reportLock __attribute__((unused)) = PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP;


static void closeOnExec(int fd)
{
  int flags = fcntl(fileno(cbi_reportFile), F_GETFD, 0);

  if (flags >= 0)
    {
      flags |= FD_CLOEXEC;
      fcntl(fd, F_SETFD, flags);
    }
}


static void openReportFile()
{
  const char *envar;

  if ((envar = getenv("SAMPLER_REPORT_FD")))
    {
      VERBOSE("%s(): $SAMPLER_REPOT_FD = \"%s\"\n", __FUNCTION__, envar);
      char *tail;
      const int fd = strtol(envar, &tail, 0);
      if (*tail == '\0')
	{
	  cbi_reportFile = fdopen(fd, "w");
	  closeOnExec(fd);
	}
    }

  else if ((envar = getenv("SAMPLER_FILE")))
    {
      VERBOSE("%s(): $SAMPLER_REPOT_FILE = \"%s\"\n", __FUNCTION__, envar);
      cbi_reportFile = fopen(envar, "w");
      closeOnExec(fileno(cbi_reportFile));
    }

  else
    VERBOSE("%s(): no reporting destination set\n", __FUNCTION__);

  unsetenv("SAMPLER_REPORT_FD");
  unsetenv("SAMPLER_FILE");

  if (cbi_reportFile)
    {
      VERBOSE("%s(): starting report to FILE 0x%p\n", __FUNCTION__, cbi_reportFile);
      fputs("<report id=\"samples\">\n", cbi_reportFile);
      fflush(cbi_reportFile);
    }
  else
    VERBOSE("%s(): not reporting\n", __FUNCTION__);
}


static void closeReportFile()
{
  fclose(cbi_reportFile);
  cbi_reportFile = 0;
}


/**********************************************************************/


static void reportAllCompilationUnits()
{
  if (cbi_reportFile)
    {
      cbi_unregisterAllUnits();
      fputs("</report>\n", cbi_reportFile);
      fflush(cbi_reportFile);
    }
}


static void reportDebugInfo()
{
  void *stack[1024];
  const int entries = backtrace(stack, sizeof(stack) / sizeof(*stack));

  fputs("<report id=\"main-backtrace\">\n", cbi_reportFile);
  fflush(cbi_reportFile);
  backtrace_symbols_fd(stack, entries, fileno(cbi_reportFile));
  fputs("</report>\n", cbi_reportFile);
}


/**********************************************************************/


#define SIGNAL_PRIOR(sig)  struct sigaction cbi_prior_ ## sig = { .sa_handler = SIG_DFL }
#define SIGNAL_CASE(sig)  case SIG ## sig: prior = &cbi_prior_ ## sig; break
#define SIGNAL_INST(sig)  do { const struct sigaction action = { .sa_handler = handleSignal }; sigaction(SIG ## sig, &action, &cbi_prior_ ## sig); } while (0)


SIGNAL_PRIOR(ABRT);
SIGNAL_PRIOR(BUS);
SIGNAL_PRIOR(FPE);
SIGNAL_PRIOR(SEGV);
SIGNAL_PRIOR(TRAP);


static void finalize()
{
  CBI_CRITICAL_REGION(reportLock, {
    if (cbi_reportFile)
      {
	reportAllCompilationUnits();
	closeReportFile();
      }
  });
}


static void handleSignal(int signum)
{
  static const struct sigaction defaultAction = { .sa_handler = SIG_DFL };
  const struct sigaction *prior;

  switch (signum)
    {
      SIGNAL_CASE(ABRT);
      SIGNAL_CASE(BUS);
      SIGNAL_CASE(FPE);
      SIGNAL_CASE(SEGV);
      SIGNAL_CASE(TRAP);
    default:
      prior = &defaultAction;
    }

  sigaction(signum, prior, 0);

  CBI_CRITICAL_REGION(reportLock, {
    if (cbi_reportFile)
      {
	reportAllCompilationUnits();
	reportDebugInfo();
	closeReportFile();
      }
  });

  raise(signum);
}


void cbi_initializeReport()
{
  VERBOSE("%s(): begin\n", __FUNCTION__);

  CBI_CRITICAL_REGION(reportLock, {
      openReportFile();
      if (cbi_reportFile)
	{
	  atexit(finalize);
	  SIGNAL_INST(ABRT);
	  SIGNAL_INST(BUS);
	  SIGNAL_INST(FPE);
	  SIGNAL_INST(SEGV);
	  SIGNAL_INST(TRAP);
	}
    });

  VERBOSE("%s(): end\n", __FUNCTION__);
}

void cbi_uninitializeReport()
{
  CBI_CRITICAL_REGION(reportLock, {
      if (cbi_reportFile)
        closeReportFile();
  });
}
