# Floating point to fixed point and fixed-point to floating point converter.
# Authors: James Hollister, Roberto Pasillas

.text


	
main:
   la    $a0, STR3   # load a message to be output
   li    $v0, 4      # syscall 4 (print_str)
   syscall           # outputs the string at $a0

   li $v0, 5		#read_int (choice)
   syscall		#read_int cont
   move $t0, $v0	#move int to $t0
   
   bne   $t0, $zero, choice_other	# decide set up FPN/FP to FP/FPN

choice_zero:
   la    $a0, STR1   # load a message to be output
   li    $v0, 4      # syscall 4 (print_str)
   syscall           # outputs the string at $a0
   
   li    $v0, 5      # syscall 5 (read_int)
   syscall           # reads an int into $v0
   move  $t0, $v0    # move first int into t0
   
   la    $a0, STR2   # enter second integer
   li    $v0, 4
   syscall
   
   li    $v0, 5
   syscall
   
   move  $a1, $v0  # a1 decimal point position
   move  $a0, $t0  # a2 fixed point number
   jal   fixed_to_float
   
   mtc1  $v0, $f12   # moves integer to floating point register
   #move   $a0, $v0
   li    $v0, 2      # syscall 2 (print_float)
   syscall           # outputs the float at $f12
   j     main
   
choice_other:
   la    $a0, STR4   # load a message to be output
   li    $v0, 4      # syscall 4 (print_str)
   syscall           # outputs the string at $a0
   
   li    $v0, 6      # syscall 6 (read_float)
   syscall           # reads an float into $v0
   
   mfc1 $t0, $f0
   
   la    $a0, STR2   # enter second integer
   li    $v0, 4
   syscall
   
   li    $v0, 5
   syscall
   
   move  $a1, $v0  # a1 decimal point position
   move  $a0, $t0  # a0 floating point number
   jal   float_to_fixed
   
   move   $a0, $v0
   li    $v0, 1      # syscall 1 (print_int)
   syscall           # outputs the int at $a0
   j     main

fixed_to_float:
	# convert fixed point to floating point
	# $a0 - fixed point number
	# $a1 - decimal position
	# returns floating point representation
	
	# check if input value is negative
	move  $t6, $zero
	slt   $t0, $a0, $zero
	bne   $t0, 1, L0
	
	not   $a0, $a0
	addi, $a0, $a0, 1        # take the twos complement

	li    $t0, 1 
	sll   $t0, $t0, 31
	move  $t6, $t0  	# set the sign bit of result to t6
	j     L1
L0:
	bne   $a0, $zero, L1
	move  $t3, $zero
	j     FIN
L1:
	clz   $t0, $a0 		#count leading zeros
	li    $t1, 31		
	sub   $t1, $t1, $t0     # t1 = normalized decimal position
	sub   $t1, $t1, $a1     # t1 = exponent
	addi   $t1, $t1, 127    # t1 = exponent + bias
	
	addi   $t0, $t0, 1
	bne    $t0, 32, L2
	move   $t3, $zero
	j      L3
L2:
	sllv   $t3, $a0, $t0   # clear left most bits of a0
	srlv   $t3, $t3, $t0   # t3 = fraction
L3:
      
	# if t3 has more than 23 bits shift right else shift left
	clz    $t2, $t3
	slti   $t7, $t2, 9
	bne    $t7, $zero, L4

	# shift left
	li     $t4, 31
	sub    $t4, $t4, $t0    # t4 = size of fraction
	li     $t5, 22
	sub    $t4, $t5, $t4
	sllv   $t3, $t3, $t4    # shift fraction to be 23 bits
	j      L5

L4:	
	# shift right
	li     $t7, 9
	sub    $t7, $t7, $t0  # 9-t0 gives shift amount for right shift
	srlv   $t3, $t3, $t7

	
L5:	
	sll    $t1, $t1, 23
	or     $t3, $t3, $t1    # combine fraction and exponent

FIN:	
	move  $v0, $t3
	or    $v0, $v0, $t6   # set the sign bit
	jr    $ra
	
float_to_fixed:
	# convert floating point to fixed point
	# SAMPLE INPUT (7,8.25) OUTPUT = 1056
	# $a0 - floating point value
	# $a1 - decimal position
	# returns fixed point integer
	
	#sign bit
	srl $t1,$a0,31
	
	#exponent
	sll $t2, $a0, 1
	srl $t2, $t2, 24
	subi $t2, $t2, 127
	
	#value extraction
	add $t2, $t2, $a1	# determine shift value => exponent + Floating Point Offset
	li $t4, 23
	sll $t3, $a0, 9		# remove exponent and signbit
	srl $t3, $t3, 9
	
	bne $a0, $zero, F0	#check if value = 0
	move $t3, $zero
	j F4
	
F0:	
	ori $t3, 8388608	# prepend 1 to fraction 
	
	slt $t0, $t3, $t2	# determine shift direction
	bne $t0, $zero, F2
	
F1:	#(t4 > t2)		  shift right
	sub $t2, $t4, $t2
	srlv $t3, $t3, $t2
	j F3
	
F2:	# (t2 > t4) 		 shift left
	sub $t2, $t2, $t4 
	sllv $t3, $t3, $t2
F3:	
	#if sign bit, 2's compliment
	beqz $t1, F4
	not $t3, $t3
	addi $t3, $t3, 1
F4:
	move  $v0, $t3
	jr    $ra
DONE:



.data
 
STR1:
   .asciiz "\nEnter the fixed point integer:\n"
STR2:
   .asciiz "Enter the decimal point position:\n"
STR3:
   .asciiz "\nEnter (0) for Fixed to Float or (1) for Float to Fixed\n"
STR4:
   .asciiz "Enter the floating point value:\n"
