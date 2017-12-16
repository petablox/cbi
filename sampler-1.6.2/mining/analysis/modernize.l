%{ // -*- c -*-
#include <errno.h>
#include <string.h>
#include <unistd.h>

#define YY_NO_INPUT

const char *scheme;
const char *tag;
%}

%option noyywrap
%option nounput
%option nodefault
%option align
%option fast
%option read

%x COUNTS


%%


<INITIAL>[0-9a-f]{32}\n {
  BEGIN(COUNTS);
  yytext[yyleng - 1] = '\0';
  printf("<%s unit=\"%s\" scheme=\"%s\">\n", tag, yytext, scheme);
}


<INITIAL>.|\n {
  fprintf(stderr,
	  "modernization error: malformed input\n"
	  "  expected unadorned compilation unit signature\n"
	  "  instead, read \"%s\"\n", yytext);
  exit(1);
}


<COUNTS>(.+\n)*\n {
  BEGIN(INITIAL);
  const size_t wrote = fwrite(yytext, 1, yyleng - 1, stdout);
  if (wrote != (size_t) yyleng - 1)
    {
      const int status = errno;
      fprintf(stderr, "modernization error: cannot write counts: %s\n", strerror(status));
      exit(status ? status : 1);
    }
  printf("</%s>\n", tag);
}


<COUNTS><<EOF>> {
  fputs("modernization error: malformed input\n"
	"  expected sequence of newline-terminated counts\n"
	"  instead, read end-of-file\n", stderr);
  exit(1);
}


<COUNTS>.+ {
  fprintf(stderr, "modernization error: malformed input\n"
	  "  expected sequence of newline-terminated counts\n"
	  "  instead, read \"%s\"\n", yytext);
  exit(1);
}


%%


#include <stdio.h>


int main(int argc, char *argv[])
{
  if (argc != 3)
    {
      fprintf(stderr, "Usage: %s <scheme> <tag>\n", argv[0]);
      exit(2);
    }

  scheme = argv[1];
  tag = argv[2];
  yylex();

  return 0;
}
