#include "work.h"


void test(int flag)
{
  if (flag)
    goto target;

  switch (flag)
    {
    case 1:
    target:
      work();
    }
}
