%{
  #include <cstdio>
  #include <iostream>
  #include <string.h>

  using namespace std;

  // stuff from flex that bison needs to know about:
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
  
  void yyerror(const char *s);
  char* tokens[10];
  int i = 0;
%}

%union {
  char *sval;
  int ival;
}

%token <sval> TEXT 
%token <sval> COMMA
%token END
%type <sval> rule

%define parse.error verbose
%%
program:
  line
  | program line
  | END
line:
  rule END {
    for (int ii = 0;ii <i ;ii++) {
      cout << tokens[ii] << ", ";
    }
    i = 0;
    //XD
  }
  ;
rule:
  TEXT{
    tokens[i++] = $1;
  }
  |
  rule COMMA TEXT {
    tokens[i++] = $3;
  }
;
%%

int main(int, char**) {
  // Open a file handle to a particular file:
  FILE *myfile = fopen("in.f", "r");
  // Make sure it is valid:
  if (!myfile) {
    cout << "I can't open in.f file" << endl;
    return -1;
  }
  // Set Flex to read from it instead of defaulting to STDIN:
  yyin = myfile;
  
  // Parse through the input:
  yyparse();
  
}

void yyerror(const char *s) {
  cout << "EEK, parse error!  Message: " << s << endl;
  // might as well halt now:
  exit(-1);
}