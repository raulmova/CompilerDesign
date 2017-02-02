/**********************************************************************/
/*                                                                    */
/* File name: bc.c                                                    */
/*                                                                    */
/* Description: This file contains the main entry point to the binary */
/*              converter.                                            */
/*                                                                    */
/* Created on:  Thu Oct 3 18:06 CDT 2013                              */
/*                                                                    */
/* History:                                                           */
/*                                                                    */
/*              Oct  3 2013 Created file                              */
/*                                                                    */
/* Key words: compilers, exam code, binary conversion                 */
/*                                                                    */
/**********************************************************************/

#include <stdio.h>                  /* Used for (f)printf() functions */
#include <stdlib.h>                                /* Used for exit() */

extern  FILE *yyin; /* *yyout; Specify the input and ouyput file names*/

/* Function prototypes */
void yyparse (void);


int main(int argc, char *argv[]){
  
  if (argc != 2){
    fprintf(stderr,"Usage: %s file\n\n",argv[0]);
    exit(1);
  }
  
  /* Start the syntax-directed translation */
  yyin = fopen(argv[1], "r");            /* Open input file as READ only */
  if (NULL == yyin){
	fprintf (stderr, "Error: Can't open %s file\n", argv[1]);
	exit (EXIT_FAILURE);
  }

  yyparse();

  exit (EXIT_SUCCESS);
}
