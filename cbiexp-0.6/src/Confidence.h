#ifndef INCLUDE_Confidence_h
#define INCLUDE_Confidence_h

#include <string>
#include "arguments.h"
#include <stdlib.h>
#include <string.h>


namespace Confidence
{
  extern const argp argp;

  extern unsigned level;
  double critical(unsigned = level);
}


#endif // !INCLUDE_Confidence_h
