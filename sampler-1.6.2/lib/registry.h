#ifndef INCLUDE_sampler_registry_h
#define INCLUDE_sampler_registry_h

#include "signature.h"


struct cbi_Unit {
  struct cbi_Unit *next;
  struct cbi_Unit *prev;
  void (*reporter)(void);
};


void cbi_registerUnit(struct cbi_Unit *);
void cbi_unregisterUnit(struct cbi_Unit *);

void cbi_unregisterAllUnits();


#endif /* !INCLUDE_sampler_registry_h */
