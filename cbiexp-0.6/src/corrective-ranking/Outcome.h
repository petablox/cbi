#ifndef INCLUDE_corrective_ranking_Outcome_h
#define INCLUDE_corrective_ranking_Outcome_h

#include <iosfwd>
#include <stdlib.h>
#include <string.h>


enum Outcome { Failure, Success };


std::ostream & operator<<(std::ostream &, Outcome);


#endif // !INCLUDE_corrective_ranking_Outcome_h
