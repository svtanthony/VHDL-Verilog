CS 161 Lab 3
TA: Jose Rodriguez

Team Leader: Roberto Pasillas
Team Members: James Hollister, Roberto Pasillas

Remarks:

Implementation converts a Fixed point(FP) to Floating point(FPN) based a given floating point offset(FPO). 

FPN to FP: The fraction is extracted then remove the leading zeros and 
append zeros to the value. The exponent is calculated as the size of the 
fraction minus the FPO.The sign bit is extracted and all the pieces are 
combined using ors to create the FP value.

FP to FPN: The sign bit, exponent , and fraction are all extracted. The 
fraction is then adjusted based on the FPO and the exponent. The sign 
value determines whether the 2's compliment is needed. The value returned 
is the FPN representation.

Known Bugs:
None detected
