%{
 /*********************************************************************/
 /*                                                                   */
 /* File name: bc.y                                                   */
 /*                                                                   */
 /* Description: This file contains the syntax and semantic definition*/
 /*              for the binary conversion progrm. The compilation    */
 /*              directive "DEBUG" is used to generate more           */
 /*              information about the internal structure operation   */
 /*              of the compiler.                                     */
 /*                                                                   */
 /* Created on:  Thu Oct 3 18:18:07 CDT 2013                          */
 /*                                                                   */
 /* History:                                                          */
 /*                                                                   */
 /*              Oct 3  2013 Created file                             */
 /*                                                                   */
 /* Key words: compilers, syntax, semantics, code generation          */
 /*                                                                   */
 /*********************************************************************/

 #include <stdio.h>                 /* Used for (f)printf() functions */
 #include <stdlib.h>                               /* Used for exit() */
 #include <math.h>                       /* For power (powf) function */

 int         lineno = 1;             /* Number of current source line */
 extern int  yylex();        /* Lexical analyzer generated from lex.l */
 extern char *yytext;                 /* Last token, defined in lex.l */
 int         position = 0;                   /* Position of the digit */
 int         up = 1;               /* Increment or decrement exponent */

 /* Declare the function prototypes */
 void  yyerror(char *string);             /* Error reporting function */

%}

 /* The following is the definition of YYSTYPE */
 %union{
   int             value_int;           /* Integer value of the digit */
   float           value_real;  /* Floating point value of the result */
 }

 /*
  * Terminals are stored as Token objects in YYSTYPE. The following
  * have no value per se, therefore no type association is made.
  */
%token DOT NL

 /* These terminals have an associated type */
%token <value_int> DIGIT

 /* These are the non-terminals with an associated type */
%type <value_real> L B

 /* Define the non-terminal used as the start symbol */
%start SP

%% /*
    * Grammar for the binary conversion, note the extra production SP
    * that allows multiple lines, this is not part of the exam.
    */
SP : S NL            { position = 0; up =1; /* Reset globals */ }
   | SP S NL         { position = 0; up =1; /* Reset globals */ }
   ;

S  : L DOT D L       {
                      #ifdef DEBUG
                         printf("Integer %g, fractional %g\n", $1, $4);
                      #endif
                      printf ("The converted value is %g\n",
                             $1 + $4);
                    }
   | L              {
                      printf ("The converted value is %g\n", $1);
                    }
   ;

L  : L B         {
                    if (up == 1) {
                        $$ = ($1 * 2) + $2;
                        #ifdef DEBUG
                           printf ("Value so far: %g\n", $$);
                        #endif
                    } else {
                        position++;
                       $$ = $1 + $2 * powf(2,-position);
                       #ifdef DEBUG
                         printf ("Value so far: %g\n", $$);
                       #endif
                    }
                  }

    | B           {
                    if (up == 1)
                       $$ = $1;                      /* Pass the value*/
                    else {
                       position++;
                       $$ = $1 * powf(2,-position);
                    }
                  }
    ;

B   : DIGIT       {
                    $$ = $1;                        /* Pass the value */
                  }
    ;

D   :             {
                    up = 0;     /* Shift right or exponentiate "down" */
                    position = 0;
                  }
    ;
%%

#include "lex.yy.c"                             /* Generated scanner */

/*                                                                    */
/* This is the error-reporting function                               */
/*                                                                    */
void  yyerror(char *string){

  fprintf(stderr,"\n%s on line #%d\n", string, lineno);
  fprintf(stderr,"Last token was \"%s\"\n", yytext);
  exit(1);
}
