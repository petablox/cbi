#ifndef INCLUDE_RawReport_h
#define INCLUDE_RawReport_h

#include <string>
#include "arguments.h"
#include <stdlib.h>
#include <string.h>


namespace RawReport
{
  extern const argp argp;

  extern std::string format(unsigned runId);
}


#endif // !INCLUDE_RawReport_h
