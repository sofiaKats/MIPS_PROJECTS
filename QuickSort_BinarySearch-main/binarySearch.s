##############################################################
# MIPS assembly program for sorting array with quicksort     #
#done by:                                                    #
# Anna Kokkinou, Katerina Beligianni, Sofia Meropi Katsaouni #
##############################################################
# REGISTER $a0 HOLDS THE RESULT   
        .data
nums:   .word 5, 8, 12, 15, 16, 19, 23, 28, 35, 39, 41, 43, 44, 52, 55, 58, 66, 72, 74, 76, 81
length: .word 21
value_to_search: .word 19
POS: .word 0

        .text
        #
        # This code loads arguments into $a registers and calls the search routine.
        # Once we get back from sorting it prints the returned value and exits.
        #
main:
        li $a0, 0       	     # left index value
        la $t0, length  	     # size is right index value
        lw $a1, 0($t0)  
        la $a2, nums    	     # pass array's base address in $a2
        lw $a3, value_to_search      # value to search for in array
  # Args are all loaded into $a register -- time to jump to search procedure
        jal binary_search       
        			     # Now we're back, with the return value in $v0
        la $t4, POS
	addi $t4, $v0, 0	     # Move result into #t4 to print
	#addi $a0, $v0, 0   	     # Move result into $a0 to print
        #li $v0, 1
        #syscall         	     # Print the result

	### PRINT POS ###
	addi $a0, $t4, 0   	     # Move result into $a0 to print
        li $v0, 1
        syscall         	     # Print the result

	sw $a0, 0($a2)		     # store result in first index of array

        li $v0, 10      	     # syscall 10 is exit
        syscall         
    
        

# PROCEDURE:  binary_search
#  Searches for a specific value in an array using binary search.
#
# Inputs:
#  $a0  Index where search begins (inclusive)
#  $a1  Index where search ends (exclusive)
#  $a2  Base address of array
#  $a3  Value to search for
# 
# Outputs:
#  $v0  Contains the position within the array at which value occurs, or
#       returns 0 if it's not in the array currently.

binary_search:
        # Begin with stack management code here - 
        # Need to save $a0, $a1, and $ra because of call to print_status and need to return 
        # Also need to save s registers
        addi $sp, $sp, -28		# make room for 7 (changing arguments, return address, and former $s registers
        sw $s0, 12($sp)			# storing s registers out of the way of current procedure (MIPS convention)
        sw $s1, 16($sp)
        sw $s2, 20($sp)
        sw $s3, 24($sp)
        # Move arguments to s registers just in case other methods don't play nice with arguments
        addi $s0, $a0, 0
        addi $s1, $a1, 0
        addi $s2, $a2, 0
        addi $s3, $a3, 0
        sw $s0, 0($sp)			# save a copy of $a0 (low index value)
        sw $s1, 4($sp)			# save a copy of $a1 (high index value)
        sw $ra, 8($sp)			# save a copy of $ra      
        
        #Body				# $a0 and $a1 registers should be in place
	addi $t0, $s0, 1		# $t0 = low + 1
        beq  $t0, $s1, end_search	# if low+1 == high, end the search

        # else...
        add $s4, $s0, $s1		# $s4 = low + high (s4 is mid)
        srl $s4, $s4, 1			# $s4 = low + high / 2 (shift is needed to lose the remainder)
	sll $t0, $s4, 2			# $t0 = mid * 4 (multiply mid by 4 for the proper address)
	add $t0, $t0, $s2		# $t0 = nums + (mid * 4) --> $t0 is address of nums[mid]
	lw $t1, 0($t0)			# $t1 = nums[mid]
        slt $t0, $s3, $t1		# if (value < nums[mid] $t0 = 1; otherwise it equals 0
	beq $t0, $zero, right_half	# jump to searching the right half if we need to search that half       
        
	# binSearch(low, mid, nums, value) - search left half

        addi $a1, $s4, 0		# put $s0 (mid) in $a1 (replace high bound) to prepare for call
        addi $a0, $s0, 0		# make sure we have the right argument for the low bound
        jal binary_search		# call binary_search with new arguments
        addi $a1, $s1, 0		# Restore only caller's former $a1 value when changed
       	j return			# jump to the stack-tidying code 
right_half:
	# binSearch(mid, high, nums, value) - search right half
	addi $t7, $t1, 0 		#final array[mid] --> found value

	addi $a0, $s4, 0		# put $s0 (mid) in $a0 (replace low bound; no need to update high bound)
	jal binary_search		# call binary search with new arguments
	addi $a0, $s0, 0		# Restore only caller's $a0 value when changed
	j return			# jump to the stack-tidying code
end_search:          
	beq $s3, $t7, exit		#if found value($t7) == searched value($s3), continue normally
not_found:
	li $s0, 0			# else we store 0 to the index
exit:
        addi $v0, $s0, 0		# $v0 = low (only passed once)
return:       				# Stack-tidying code here - only what is needed here.
	lw $s0, 12($sp)			# loading s registers (MIPS convention)
        lw $s1, 16($sp)
        lw $s2, 20($sp)
        lw $s3, 24($sp)
	lw $ra, 8($sp)			# Restore $ra to get home
	addi $sp, $sp, 28
	jr $ra				# Jump back to caller