#ifndef INCLUDE_sampler_bounds_h
#define INCLUDE_sampler_bounds_h

#include "../signature.h"


void cbi_boundsReportBegin(const cbi_UnitSignature);
void cbi_boundsReportEnd();

void cbi_boundDumpSignedChar(signed char, signed char);
void cbi_boundDumpUnsignedChar(unsigned char, unsigned char);
void cbi_boundDumpSignedShort(signed short, signed short);
void cbi_boundDumpUnsignedShort(unsigned short, unsigned short);
void cbi_boundDumpSignedInt(signed int, signed int);
void cbi_boundDumpUnsignedInt(unsigned int, unsigned int);
void cbi_boundDumpSignedLong(signed long, signed long);
void cbi_boundDumpUnsignedLong(unsigned long, unsigned long);
void cbi_boundDumpSignedLongLong(signed long long, signed long long);
void cbi_boundDumpUnsignedLongLong(unsigned long long, unsigned long long);
void cbi_boundDumpPointer(const void *, const void *);


#ifdef CIL
#pragma cilnoremove("cbi_boundDumpSignedChar")
#pragma cilnoremove("cbi_boundDumpUnsignedChar")
#pragma cilnoremove("cbi_boundDumpSignedShort")
#pragma cilnoremove("cbi_boundDumpUnsignedShort")
#pragma cilnoremove("cbi_boundDumpSignedInt")
#pragma cilnoremove("cbi_boundDumpUnsignedInt")
#pragma cilnoremove("cbi_boundDumpSignedLong")
#pragma cilnoremove("cbi_boundDumpUnsignedLong")
#pragma cilnoremove("cbi_boundDumpSignedLongLong")
#pragma cilnoremove("cbi_boundDumpUnsignedLongLong")
#pragma cilnoremove("cbi_boundDumpPointer")
#endif /* CIL */


#endif /* !INCLUDE_sampler_bounds_h */
