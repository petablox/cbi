#include "work.h"


void test(int flag)
{
  if (flag)
    goto target;

  switch (flag)
    {
    target:
    case 1:
      work();
    }
}
