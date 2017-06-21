CS 161 Lab 4
TA: Jose Rodriguez

Team Leader: James Hollister
Team Members: James Hollister, Roberto Pasillas

Remarks:
Implementation of simple ALU and datapath control units. 
Supports the following instruction types:
add, addu, addi
sub, subi
slt
not, nor
or
and
lw, sw
beq

Note that subi is not implemented in control unit because it will be 
translated to an addi instruction by assembler. Similarly, NOT is also
not implemented in control unit as it will translated to a NOR with 0 by
the assembler.


Known Bugs:
No known bugs.