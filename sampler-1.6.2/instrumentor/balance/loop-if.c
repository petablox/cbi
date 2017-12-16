#include "work.h"

void test(void)
{
 top:
    if (work())
      goto top;
    else
      work();
}
