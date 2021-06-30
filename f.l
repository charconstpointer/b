%{
  #include <cstdio>
  #include <string.h>
  #include "f.tab.h"  // to get the token types from Bison

%}
%%
END       {return END;}
[ \t\n] ;
[a-zA-Z0-9]+   {yylval.sval = strdup(yytext);return TEXT;}
,           {yylval.sval = strdup(yytext); return COMMA;}
%%
