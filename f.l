%{
  #include <iostream>
  #include "f.tab.h"
  using namespace std;
  extern int yylex();
  int linenum=0;
%}
%option noyywrap
%%
[ \t\n]           ;
[0-9]+\.[0-9]+    { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+            { yylval.ival = atoi(yytext); return INT; }
[a-zA-Z0-9]+      {
  // We have to strdup yytext because Flex will change it for the next token.
  // Note that this memory must be freed somewhere, so that's why we call
  // free() above in the Bison section.  (Aside: we use free() instead of
  // delete because strdup is a C function that uses malloc, not a C++
  // function that uses new.)
  yylval.sval = strdup(yytext);
  return STRING;
}
%%
int main(int, char**) {
  FILE *myfile = fopen("in.f", "r");
  if (!myfile) {
    cout << "I can't open in.f!" << endl;
    return -1;
  }
  yyin = myfile;
  while (yylex());
}