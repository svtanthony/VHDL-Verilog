CS 161 Lab 7 
TA: Jose Rodriguez 
 
Team Leader: Selik Samai 
Team Members: James Hollister, Roberto Pasillas, Selik Samai
Modified: Roberto Pasillas -- modified README, makefile, and added a python version. 
 
We load our trace file into a vector so that we only have to read from the file once instead of 
each iteration.  
 
We use nested vectors to simulate the cache where the associativity determines the number of 
columns for the 2D matrix and the rows are determined by the (cache_size/ BLOCK_SIZE) / 
associativity.   
 
Once we have calculated the matrix size, we then build cache and then read memory access 
from file where we determine if cache hits and miss. 
 
We included a makefile that makes testing easier.
 * make is used to compile the program. The object file is called cache.
 * ./cache [your file] runs the executable with a specific trace file. (must run make first)
 * make run will run the program with the included trace file.
 * make clean will remove the object file (cache).
 * make python will run the python version. (it is much slower).
 
The left­most numbers indicate the set associativity while top most numbers indicate the cache 
size for each policy.  
 
No known bugs.   
