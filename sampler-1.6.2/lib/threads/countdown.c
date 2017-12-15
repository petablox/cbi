#include <limits.h>
#include "countdown.h"


CBI_THREAD_LOCAL int cbi_nextEventCountdown = INT_MAX;
