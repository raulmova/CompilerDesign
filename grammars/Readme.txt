This directory contains several grammars that have been covered in class.
You can check that the output generated by bison matches the manual
algorithm that was employed in class to create the LALR parse tables.
The command to generate the LALR output in Bison is:

bison -v file.y

The output is file.output. Remember that the order of the states will be
different from the algorithm covered in class because the acceptor state
is always one in the manual algorithm. However, you can follow the states
and compare the Action and Goto tables. They will be similar (only the state assignment is different).
