/**********************************************************************/
/*                                                                    */
/* File name: bc.l                                                    */
/*                                                                    */
/* Description: This file contains the lexical definition of the      */
/*              tokens for the binary conversion program. The         */
/*              conditional compilation directive "DEBUG" is used to  */
/*              generate more information about the token structure   */
/*              and internal scanner operation.                       */
/*                                                                    */
/* Created on:  Thu Oct 3 18:11:38 CDT 2013                           */
/*                                                                    */
/* History:                                                           */
/*                                                                    */
/*              Oct 3  2013 Created file                              */
/*                                                                    */
/* Key words: compilers, lexical definition, tokens                   */
/*                                                                    */
/**********************************************************************/

%{
 /*
  * Note the empty space at the beginning of each line. This is done to
  * force flex to treat these lines as comments so they get copied to
  * the output C file without any processing.
  */
 #include <string.h>                 /* Used for the string functions */
 #include <stdio.h>                  /* Used to handle printf & ohers */
 #include <stdlib.h>                    /* Used for the atoi function */

 #include "bc.tab.h"                              /* Token definition */

 extern int lineno;                /* Line counter defined in bc.y    */

%}

%option nounput
%option noinput

 /* Macro definition */
digit          [0-1]
newline        \n
creturn        \r
whitespace     [ \t]+

%%

{digit}       {
                #ifdef DEBUG
                  printf ("Line: %d, \n",lineno);
                  printf ("token: NUMBER\n");
                #endif
                /* Return numeric value */
                yylval.value_int = atoi (yytext);
                return(DIGIT);                 /* Indicate token type */
               }

{newline}      {
                 lineno++;
                 return (NL);
               }

{creturn}      {/* Treat as whitespace */}

{whitespace}   {/* Skip whitespace */}

"."            {
                #ifdef DEBUG
                  printf ("Line: %d, \n",lineno);
                  printf ("token: PERIOD\n");
                #endif

                return(DOT);                   /* Indicate token type */
                }

.             {
               /* Unrecognized symbol, inform and skip */
               printf("\nlexical error line: %d, ",lineno);
               printf("unrecognized symbol -> %s\n", yytext);
               printf("continuing with the translation\n\n");
              }
%%
