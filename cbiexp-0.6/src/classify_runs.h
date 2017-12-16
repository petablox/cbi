#ifndef CLASSIFY_RUNS_H
#define CLASSIFY_RUNS_H

#include <vector>
#include <stdlib.h>
#include <string.h>

extern unsigned num_sruns, num_fruns;
extern std::vector<bool> is_srun, is_frun;

extern void classify_runs();


#endif // !CLASSIFY_RUNS_H
