#include <stdio.h>


int main(int argc, char *argv[])
{
  int arg;

  for (arg = 1; arg <= argc; ++arg)
    {
      char *chr;

      if (arg > 1)
	putc(' ', stdout);

      for (chr = argv[arg]; *chr; ++chr)
	putc(toupper(*chr), stdout);
    }

  putc('\n', stdout);
  return 0;
}
