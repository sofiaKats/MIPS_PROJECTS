.text
.globl _start
_start:
	la $s7, myarr      # array of given numbers
	addi $t0, $zero, 0 # initialize t0 = 0
	addi $t6, $zero, 3 # number of trios
	addi $s4, $zero, 0 # initialize t4 = 0
array_loop:
	beq $t0, $t6, print1	# for loop 3 times for each trio
	addi $t0, $t0, 1	# loop counter

	lw $s1, 0($s7) 		# store first number of array (int 4 bytes)
	lw $s2, 4($s7) 		# store second number of array
	lw $s3, 8($s7) 		# store third number of array

	addi $s7, $s7, 12 	# goes to start number of next trio
	addi $a0, $s1, 0	
	addi $a1, $s2, 0
	jal GCD

	addi $s1, $v0, 0	# assign gcd to $s1 
	addi $s2, $s3, 0	# assign $s3 to $s2

	addi $a0, $s1, 0	# and assign s1, s2 to a0, a1 to use them in GCD label
	addi $a1, $s2, 0
	jal GCD


	sw $v0, gcd($s4)	# save final result to array gcd
	addi $s4, $s4, 4	# increases counter of array

	j array_loop
print1:
	li $t0, 0
	la $t1, gcd
print2:
	beq $t0 , $t6, exit

	lw $t2, 0($t1)
	addi $t1, $t1, 4

	# syscall to print value
	addi $a0,$t2,0
    	li $v0,1
    	syscall # print result

	 # optional - syscall number for printing character (space)
    	li      $a0, 32
    	li      $v0, 11  
    	syscall
	#increment counter
    	addi    $t0, $t0, 1
	j print2
exit:
	li $v0, 10
	syscall


GCD:

    	addi $sp, $sp, -12
    	sw $ra, 0($sp) 		# save last address from _start label
    	sw $s1, 4($sp) 		# save value $s1 into stack , later s2
    	sw $s2, 8($sp)		# save value $s2 into stack , later s3

    	addi $s0, $a0, 0 	# s0 = a0 (gives s0, first value to examine for gcd)
    	addi $s1, $a1, 0 	# s1 = a1 (gives s1, second value to examine for gcd)

	addi $t1, $zero, 0 	# $t1 = 0, used to branch at GCD label
    	beq $s1, $t1, Stop 	# if s1 == 0 Stop

    	addi $a0, $s1, 0 	# make a0 = $s1
    	div $s0, $s1 		 
    	mfhi $a1 		# reminder of s0/s1 which is equal to s0%s1

    	jal GCD
	#nop

Stop:
	addi $v0, $s0, 0 	# return $v0 = $s0, s0 holds the gcd value
	lw $ra, 0 ($sp)  	# assign $ra with last adress at _start
	addi $sp,$sp , 12 	# bring back stack pointer
	jr $ra
	nop

 .data 
myarr: .word 12, 6, 3, 4, 2, 8, 1, 4, 10
gcd:   .space 8