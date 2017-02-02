####################################################################
#
# File name:    Makefile
#
# Description:  Flex Makefile
#
# History:
#   Fri Jan 28 2005 Abelardo Lopez   File created.
#   Tue Aug 29 2006 Abelardo Lopez   Changed byacc for bison
#   Wed Feb 01 2017 Abelardo Lopez   New formating
#
####################################################################
#
# Define the compiler optimization flags
#
COPT    = -O2
COPT2   = -Wall -O2
CDBG    = -g -DDEBUG
CC      = gcc
LEX     = flex
YACC    = bison
#
# Define the target names
#
TARGET_LEX =  calc.l
TARGET_BISON= calc.y
TARGET_GRAM = calc_grammar.y
TARGET_NAME=  calc
#
# Rule definitions for target builds
#
all:
	$(YACC) -v $(TARGET_BISON)
	$(LEX) $(TARGET_LEX)
	$(CC) $(COPT) -o $(TARGET_NAME) $(TARGET_NAME).tab.c -ll

grammar:
	$(YACC) -v $(TARGET_GRAM) -o $(TARGET_NAME).tab.c
	$(LEX) $(TARGET_LEX)
	$(CC) -DGRAMMAR $(COPT) -o $(TARGET_NAME) $(TARGET_NAME).tab.c -ll

clean:
	rm -f *~ core lex.yy.c $(TARGET_NAME).tab.* $(TARGET_NAME).output

clobber: clean
	rm -f $(TARGET_NAME)
