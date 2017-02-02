########################################################################
#
# File name:    Makefile
#
# Description:  Makefile for the binary conversion progran for the
#               translators class
#
# History:
#          Thu Oct 3 18:06 2013  File created
#          Thu Feb 2 10:04 2017  New format
#
########################################################################
#
# Define the compiler optimization flags
COPT    = -O2
COPT2   = -Wall -pedantic -O2
CDBG    = -g -DDEBUG
CC      = gcc
LEX     = flex
YACC    = bison
#
# Define the target names
#
TARGET_LEX   = bc.l
TARGET_BISON = bc.y
TARGET_NAME  = bc
TARGET_INPUT = in
#
# Rule definitions for target builds -d generated the bc.tab.h file
#
all:
	$(YACC) -v -d $(TARGET_BISON) -o $(TARGET_NAME).tab.c
	$(LEX) $(TARGET_LEX)
	$(CC) $(COPT2) -o $(TARGET_NAME) $(TARGET_NAME).tab.c \
    $(TARGET_NAME).c -ll
	clear; echo "Running the conversion program"
	./$(TARGET_NAME) $(TARGET_INPUT)

debug:
	$(YACC) -v -d $(TARGET_BISON) -o $(TARGET_NAME).tab.c
	$(LEX) $(TARGET_LEX)
	$(CC) $(CDBG) -o $(TARGET_NAME) $(TARGET_NAME).tab.c \
    $(TARGET_NAME).c -ll
	./$(TARGET_NAME) $(TARGET_INPUT)

clean:
	rm -f *~ core lex.yy.c $(TARGET_NAME).tab.* $(TARGET_NAME).output

clobber: clean
	rm -f $(TARGET_NAME)
