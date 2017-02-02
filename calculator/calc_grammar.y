%{
#include <string.h>
#include <stdio.h>

  /* Function definitions */
void yyerror (char *string);

 /* Removes the warning of yylex() not defined when using C99 */
#if YYBISON
    union YYSTYPE;
    int yylex();     // Should be int yylex(union YYSTYPE *, void *);
#endif

%}

 /* NAME is used for identifier tokens */
 /* NUMBER is used or real numbers */
%token NAME
%token NUMBER

%%
stmt_lst: stmt_lst statement '\n'   {
                                        printf ("No errors in the line\n");
                                    }
        | statement '\n'            {
                                        printf ("No errors in the line\n");
                                    }
        ;

statement: NAME '=' expression
        | expression
        ;

expression: expression '+' term
        | expression '-' term
        | term
        ;

term: term '*' factor
        | term '/' factor
        | factor
        ;

factor:  '(' expression ')'
        | NUMBER
        | NAME
        | '-' NUMBER
        ;
%%

/* Function prototype for yylex() */
int yylex();

#include "lex.yy.c"

/* Bison does NOT implement yyerror, so define it here */
void yyerror (char *string){
  printf ("%s\n",string);
}

/* Bison does NOT define the main entry point so define it here */
int main (void){
  yyparse();
}
