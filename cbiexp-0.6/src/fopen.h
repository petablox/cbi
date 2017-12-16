#ifndef INCLUDE_fopen_h
#define INCLUDE_fopen_h

#include <cstdio>
#include <string>
#include <stdlib.h>
#include <string.h>


FILE *fopenRead(const char *);
FILE *fopenRead(const std::string &);

FILE *fopenWrite(const char *);
FILE *fopenWrite(const std::string &);


#endif // !INCLUDE_fopen_h
