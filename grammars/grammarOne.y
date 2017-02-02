%{
#include <string.h>
#include <stdio.h>

  /* Function definitions */
void yyerror (char *string);
%}

%%
S:  'a'A'd'
    |  'b'B'd'
    |  'a'B'e'
    |  'b'A'e'
    ;

A:  'c'
    ;

B:  'c'
    ;

%%

/* Bison does NOT implement yyerror, so define it here */
void yyerror (char *string){
  printf ("%s",string);
}

/* Bison does NOT define the main entry point so define it here */
main (){
  yyparse();
}
