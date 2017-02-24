/**
 * Copyright (c) 2016 Abelardo López Lagunas. All rights reserved.
 *
 * @file    HashTest.c
 *
 * @author  Abelardo López Lagunas
 *
 * @brief   This program tests how the hash-management routines work.
 *
 * @date    Thu 12 May 2016 11:12 DST
 *
 * Usage    The program reads a text file with the elements that will
 *          be converted into nodes in a hash table The usage form is:
 * @code
 *          HashTest file.txt
 * @endcode
 *
 * References Based on my own code
 *
 * File formats:
 *          The input file should have four elements per line in ASCII
 *          format. The first one is a string and the rest are integers.
 *          The hashing will be done using the string element.
 *
 * Restrictions:
 *          If the input file is not in ASCII format the program exits.
 *
 * Revision history:
 *
 *          Thu 12 May 2016 11:13 - Created based on listTest.c
 *          Thu 19 May 2016 11:27 - Added unit tests for insertion, removal,
 *                                  traversal, and destruction.
 *
 * @warning On any unrecoverable error, the program exits
 *
 * @note    This code will be used as a tutorial on pointers and data
 *          structures, in particular has tables.
 *
 */
#include <stdio.h>                                    // Used for printf
#include <stdlib.h>                     // Used for malloc, & EXIT codes
#include <assert.h>                         // Used for the assert macro
#include <string.h>                        // For strcmp, strlen, strcpy
#include <glib.h>             // Bring in glib for all hashing functions
#include "FileIO.h"        // Used for the file access support functions
#include "UserDefined.h"        // The Symbol Table management functions

/** @def  NUMPARAMS
 * @brief This is the expected number of parameters from the command line.
 */
const int NUMPARAMS = 2;

/*************************************************************************
 *                           Main entry point                            *
 *************************************************************************/
int main (int argc, const char * argv[]) {          // Program entry point
    
   FILE       * fp;                                 // Pointer to the file
   GHashTable * theTable_p;                   // Pointer to the hash table
   entry_p      node_p;                        // Node in the symbol table

    /* Check if the number of parameters is correct */
    if (argc < NUMPARAMS){
        printf("Need a file with the test data\n");
        printf("Abnormal termination\n");
        exit (EXIT_FAILURE);
    } else {
       fp = fopen (argv[1],"r");           // Open file for read operation
       if (!fp) {                                     // There is an error
            printf ("The filename: %s does not exist or is corrupted\n",
                    argv[1]);
            printf ("Abnormal termination\n");
          exit (EXIT_FAILURE);                    // Terminate the program
        } else {
           /* Create the hash table, use the variable name (a string) as
            * the hash key. Note that we use the g_hash_table_new_full to
            * handle the deallocation of memory for the data structure
            * through a user defined function (FreeItem)
            */
           theTable_p = g_hash_table_new_full(g_str_hash, g_str_equal,
                                              NULL,
                                              (GDestroyNotify)FreeItem);

           // Insert some variables into the hash table.
           while (!feof(fp)){
			// Allocate memory for new item from the input file
              /* Note: evaluation order of function arguments is
               * implementation dependent and since both functions read
               * from the SAME input file this can cause problems in some
               * UNIX flavors (e.g. linux/gcc) so serialize the file
               * access
               */
              char * string = GetString(fp);
              int type      = GetInt(fp);
              int scope     = GetInt(fp);
              int line      = GetInt(fp);

              node_p = NewItem(string, type, scope, line);
              g_hash_table_insert(theTable_p, node_p->name_p, node_p);
           }
        }
       
       // Perform some searches in the table
       printf("\n\tTest searching for an existing item\n");
       node_p = g_hash_table_lookup(theTable_p, "Louie");
       if (PrintItem(node_p) != EXIT_SUCCESS)
          printf("Error while searching for an item\n");

       // Print the entire table
       printf("\n\tPrint the entire table\n");
       if (PrintTable(theTable_p) != EXIT_SUCCESS)
          printf("Error while printing the symbol table");

       // Now add an item to the symbol table
       node_p = NewItem("LaunchPad", real, 1, 11);
       g_hash_table_insert(theTable_p, node_p->name_p, node_p);

       printf("\n\tSymbol table after new item %s is added:\n",
              node_p->name_p);

       if (PrintTable(theTable_p) != EXIT_SUCCESS)
          printf("Error while printing the symbol table");

       // Remove an item from the table
       if (g_hash_table_remove(theTable_p, "LaunchPad") == TRUE){
          printf("\n\t Table after removing LaunchPad\n");
          if (PrintTable(theTable_p) != EXIT_SUCCESS)
             printf("Error while printing the symbol table");
       } else {
          printf("Error while removing an existing item\n");
       }

       // Destroy the hash table
       g_hash_table_destroy(theTable_p);

       fclose (fp);                       /* Close the input data file */

       return (EXIT_SUCCESS);
    }
}

