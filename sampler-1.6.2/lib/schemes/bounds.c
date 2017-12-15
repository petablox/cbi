#include <stdio.h>
#include "../report.h"
#include "bounds.h"
#include "samples.h"


void cbi_boundsReportBegin(const cbi_UnitSignature signature)
{
  cbi_samplesBegin(signature, "bounds");
}


void cbi_boundsReportEnd()
{
  cbi_samplesEnd();
}


/**********************************************************************/


void cbi_boundDumpSignedChar(signed char min, signed char max)
{
  fprintf(cbi_reportFile, "%hhd\t%hhd\n", min, max);
}


void cbi_boundDumpUnsignedChar(unsigned char min, unsigned char max)
{
  fprintf(cbi_reportFile, "%hhu\t%hhu\n", min, max);
}


void cbi_boundDumpSignedShort(signed short min, signed short max)
{
  fprintf(cbi_reportFile, "%hd\t%hd\n", min, max);
}


void cbi_boundDumpUnsignedShort(unsigned short min, unsigned short max)
{
  fprintf(cbi_reportFile, "%hu\t%hu\n", min, max);
}


void cbi_boundDumpSignedInt(signed int min, signed int max)
{
  fprintf(cbi_reportFile, "%d\t%d\n", min, max);
}


void cbi_boundDumpUnsignedInt(unsigned int min, unsigned int max)
{
  fprintf(cbi_reportFile, "%u\t%u\n", min, max);
}


void cbi_boundDumpSignedLong(signed long min, signed long max)
{
  fprintf(cbi_reportFile, "%ld\t%ld\n", min, max);
}


void cbi_boundDumpUnsignedLong(unsigned long min, unsigned long max)
{
  fprintf(cbi_reportFile, "%lu\t%lu\n", min, max);
}


void cbi_boundDumpSignedLongLong(signed long long min, signed long long max)
{
  fprintf(cbi_reportFile, "%Ld\t%Ld\n", min, max);
}


void cbi_boundDumpUnsignedLongLong(unsigned long long min, unsigned long long max)
{
  fprintf(cbi_reportFile, "%Lu\t%Lu\n", min, max);
}


void cbi_boundDumpPointer(const void * min, const void * max)
{
  fprintf(cbi_reportFile, "%p\t%p\n", min, max);
}
