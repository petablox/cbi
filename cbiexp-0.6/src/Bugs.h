#ifndef INCLUDE_Bugs_h
#define INCLUDE_Bugs_h

#include <vector>
#include <stdlib.h>
#include <string.h>

using namespace std;

class Bugs {
    public:
        Bugs();
        vector <int> * bugIndex();
    private:
        vector<int> * bugIds;
};

#endif // !INCLUDE_Bugs_h

