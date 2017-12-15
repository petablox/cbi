#define _GNU_SOURCE		/* for PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP */

#include <pthread.h>
#include "lock.h"
#include "../registry.h"
#include "../report.h"


struct cbi_Unit cbi_unitAnchor = { &cbi_unitAnchor,
				   &cbi_unitAnchor,
				   0 };

static unsigned unitCount;

static pthread_mutex_t unitLock __attribute__((unused)) = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;


void cbi_registerUnit(struct cbi_Unit *unit)
{
  CBI_CRITICAL_REGION(unitLock, {
    if (!unit->next && !unit->prev)
      {
	++unitCount;
	unit->prev = &cbi_unitAnchor;
	unit->next = cbi_unitAnchor.next;
	cbi_unitAnchor.next->prev = unit;
	cbi_unitAnchor.next = unit;
      }
  });
}


void cbi_unregisterUnit(struct cbi_Unit *unit)
{
  CBI_CRITICAL_REGION(unitLock, {
    if (unit->next && unit->prev)
      {
	unit->prev->next = unit->next;
	unit->next->prev = unit->prev;
	unit->prev = unit->next = 0;

	if (unitCount)
	  {
	    if (cbi_reportFile)
	      unit->reporter();

	    --unitCount;
	  }
      }
  });
}


void cbi_unregisterAllUnits()
{
  CBI_CRITICAL_REGION(unitLock, {
    while (cbi_unitAnchor.next != &cbi_unitAnchor)
      cbi_unregisterUnit(cbi_unitAnchor.next);
  });
}
