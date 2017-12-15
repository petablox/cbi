#include "library.h"


static int libraryCounter;


void libraryFunction(int direction)
{
  if (direction)
    ++libraryCounter;
}
