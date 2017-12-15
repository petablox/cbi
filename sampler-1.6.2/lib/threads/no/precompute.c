#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../random-online.h"
#include "../random-offline-size.h"


int cbi_nextEventCountdown;


static void writeCountdown(FILE *outfile, int value)
{
  const size_t actual = fwrite(&value, sizeof(value), 1, outfile);
  if (actual != 1)
    fprintf(stderr, "precompute: cannot write countdown: %s\n", strerror(errno));
}


int main(int argc, char *argv[])
{
  if (argc != 2)
    {
      fprintf(stderr, "Usage: %s <outfile>\n", argv[0]);
      exit(2);
    }
  else
    {
      const char * const filename = argv[1];
      FILE * const outfile = fopen(filename, "w");
      if (!outfile)
	{
	  fprintf(stderr, "precompute: cannot open \"%s\" for writing: %s\n", filename, strerror(errno));
	  exit(1);
	}
      else
	{
	  int slot = CBI_PRECOMPUTE_COUNT;
	  while (slot--)
	    {
	      writeCountdown(outfile, cbi_nextEventCountdown);
	      cbi_nextEventCountdown = cbi_getNextEventCountdown();
	    }

	  fclose(outfile);
	}
    }

  return 0;
}
