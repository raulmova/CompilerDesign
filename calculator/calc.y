%{
#include <string.h>
#include <stdio.h>
#include "table.h"

 /* Function definitions */
void yyerror (string input);

 /* Removes the warning of yylex() not defined when using C99 */
#if YYBISON
    union YYSTYPE;
    int yylex();     // Should be int yylex(union YYSTYPE *, void *);
#endif

%}

 /* Define the elements of the attribute stack */
%union {
  float dval;
  struct symtab *symp;
}

%token <symp> NAME    // NAME is used for identifier tokens
%token <dval> NUMBER  // NUMBER is used or real numbers

 /* Specify the attribute for those non-terminal symbols of interest */
%type <dval> expression term factor

%%
stmt_lst: stmt_lst statement '\n'
        | statement '\n'
        ;

statement:  NAME '=' expression     {
                                        $1->value = $3;
                                        printf("%s= %g\n", $1->name,
                                        $1->value);
                                    }
            | expression            {
                                        printf("= %g\n", $1);
                                    }
            ;

expression:   expression '+' term   {
                                        $$ = $1 + $3;
                                    }
            | expression '-' term   {
                                        $$ = $1 - $3;
                                    }
            | term
            ;

term:         term '*' factor       {
                                        $$ = $1 * $3;
                                    }
            | term '/' factor       {
                                        if($3 == 0.0)
                                            yyerror("divide by zero");
                                        else
                                           $$ = $1 / $3;
                                    }
            | factor                {
                                        $$ = $1;
                                    }
            ;

factor:     '(' expression ')'      {
                                        $$ = $2;
                                    }
            | NUMBER                {
                                        $$ = $1;
                                    }
            | NAME                  {
                                        $$ = $1->value;
                                    }
            | '-' NUMBER            {
                                        $$ = -$2;
                                    }
            ;
%%

/* Function prototype for yylex() */
int yylex();

/* This is where the flex is included */
#include "lex.yy.c"

/* Bison does NOT implement yyerror, so define it here */
void yyerror (string input){
  printf ("%s\n",input);
}

/* This function looks for a name in the symbol table, if it is */
/* not there it store it in the next available space.           */
struct symtab *symlook(string s) {
    string p;
    struct symtab *sp;

    for(sp = symtab; sp < &symtab[NSYMS]; sp++) {
        /* is it already here? */
        if(sp->name && !strcmp(sp->name, s))
            return sp;

        /* is it free */
        if(!sp->name) {
            sp->name = strdup(s);
            return sp;
        }
        /* otherwise continue to next */
    }
    yyerror("Too many symbols");
    exit(1);    /* cannot continue */
} /* symlook */

/* Bison does NOT define the main entry point so define it here */
int main (){
  yyparse();
  return 0;
}
