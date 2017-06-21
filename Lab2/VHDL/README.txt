CS 161 Lab 2
TA: Jose Rodriguez

Team Leader: Roberto Pasillas
Team Members: James Hollister, Roberto Pasillas

Remarks:
Carryout is set when we need an additional nibble to represent the result.
Overflow is set by the ALU that does binary operations.

By design, unsigned subtraction will give a bad value when a larger value is subtracted from a
smaller value. This was done because in binary the result will be too large to represent in BCD.

Implementation converts BCD inputs to binary, the ALU does the requested operation, the binary 
result is then converted to BCD.


Known Bugs:
ALU error from LAB 1 still persist.
