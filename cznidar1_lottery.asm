#Christian Znidarsic
#EN.605.204 Computer Organization
#3/4/22
.data
pool1prompt: .asciiz "Enter first pool size: \n"
choose1prompt: .asciiz "Enter first choose size: \n"
pool2prompt: .asciiz "Enter second pool size: \n"
choose2prompt: .asciiz "Enter second choose size: \n"

newline: .asciiz "\n"
answerMessage: .asciiz "The odds are 1 in "


.text

main:
	#GET USER INPUT#########################################################
	# print text requesting user input
	li $v0, 4
	la $a0, pool1prompt
	syscall
	# read integer input from user
	li $v0, 5
	syscall
	#store the result from $v0 into $s0
	add $s0, $zero, $v0
	

	# print text requesting user input
	li $v0, 4
	la $a0, choose1prompt
	syscall
	# read integer input from user
	li $v0, 5
	syscall
	#store the result from $v0 into $s1
	add $s1, $zero, $v0
	

	# print text requesting user input
	li $v0, 4
	la $a0, pool2prompt
	syscall
	# read integer input from user
	li $v0, 5
	syscall
	#store the result from $v0 into $s2
	add $s2, $zero, $v0
	

	# print text requesting user input
	li $v0, 4
	la $a0, choose2prompt
	syscall
	# read integer input from user
	li $v0, 5
	syscall
	#store the result from $v0 into $s3
	add $s3, $zero, $v0
	##########################################################################
	
	
	
	
	
	#CALCULATE ODDS OF FIRST EVENT HAPPENING##################################
	#LOAD FIRST POOL DATA
	#$a0 now contains first choose size
	add $a0, $zero, $s1
	
	
	#calculate the denominator
	jal factrl
	#store the result from $v0 into $t4
	add $t4, $zero, $v0
	
	
	#LOAD FIRST CHOOSE DATA
	#$a0 now contains first pool size
	add $a0, $zero, $s0
	#$a1 now contains first choose size
	add $a1, $zero, $s1
	
	
	#calculate the numerator
	jal numerator
	#store the result from $v0 into $t5
	add $t5, $zero, $v0
	
	
	# divide numerator by factrl and store in $s5
	div $s5, $t5, $t4
	###########################################################################
	
	
	
	
	
	#CALCULATE ODDS OF SECOND EVENT HAPPENING##################################
	#LOAD SECOND POOL DATA
	#$a0 now contains second choose size
	add $a0, $zero, $s3
	
	
	#calculate the denominator
	jal factrl
	#store the result from $v0 into $t4
	add $t4, $zero, $v0

	
	#LOAD SECOND CHOOSE DATA
	#$a0 now contains second pool size
	add $a0, $zero, $s2
	#$a1 now contains second choose size
	add $a1, $zero, $s3
	
	
	#calculate the numerator
	jal numerator
	#store the result from $v0 into $t5
	add $t5, $zero, $v0

	
	#divide numerator by factrl and store in $s6
	div $s6, $t5, $t4
	############################################################################
	
	
					
					
					
	#CALCULATE ODDS OF BOTH EVENTS HAPPENING####################################								
	#multiply the odds of each event occurring to get odds of both occurring								
	mul $s7, $s6, $s5
	############################################################################
	
	
	
	
	
	#DISPLAY FINAL RESULT#######################################################
	# print a newline
	li $v0, 4
	la $a0, newline
	syscall
	
	#print answerMessage
	li $v0, 4
	la $a0, answerMessage
	syscall
	
	#print the final result in $s7
	li $v0, 1
	move $a0, $s7
	syscall
	
	#print a newline
	li $v0, 4
	la $a0, newline
	syscall
	############################################################################
	
	
	

	# exit program
	li $v0, 10
	syscall





# Given n, in register $a0 ; 
# calculate n!, store and return the result in register $v0 
factrl:		

	sw $ra, 4($sp) # save the return address 
	sw $a0, 0($sp) # save the current value of n 
	addi $sp, $sp, -8 # move stack pointer 

	slti $t0, $a0, 2 # save 1 iteration, n=0 or n =1; n!=1 
	beq $t0, $zero, L1 # not less than 2 , calculate n(n - 1)! 
	addi $v0, $zero, 1 # n=1; n!=1 
	jr $ra # now multiply 

L1: 

	addi $a0, $a0, -1 # n = n - 1 

	jal factrl # now (n - 1)! 

	addi $sp, $sp, 8 # reset the stack pointer 
	lw $a0, 0($sp) # fetch saved (n - 1) 
	lw $ra, 4($sp) # fetch return address 
	mul $v0, $a0, $v0 # multiply (n)*(n - 1) 
	jr $ra # return value n!
	
	




#this function calculates the numerator using a while loop
numerator:
	#save return address from caller, as well as $s0 and $s1 ($s0 & $s1 not required here, added as an exercise)
	addi $sp, $sp, -4 # move stack pointer 
	sw $ra, 0($sp) # save the return address
	addi $sp, $sp, -4 # move stack pointer 
	sw $s0, 0($sp) # save $s0
	addi $sp, $sp, -4 # move stack pointer 
	sw $s1, 0($sp) # save $s1
	
	
	#$t0 now contains pool size n
	add $t0, $zero, $a0
	#$t1 now contains choose size k
	add $t1, $zero, $a1
	
	#set $t2 = $t0 - $t1 (n-k)
	sub $t2, $t0, $t1
	
	
	#WHILE LOOP 
	#(while n > (n-k))
	#	val = val * n;
	#	n = n - 1;
	li $t3, 1
	loop:
	ble $t0, $t2, end
	mul $t3, $t3, $t0
	sub $t0, $t0, 1
	j loop
	end:
	
	#move result to $v0 for return
	add $v0, $zero, $t3
	
	
	#restore return address from caller, as well as $s0 and $s1 ($s0 & $s1 not required here, added as an exercise)
	lw $s1, 0($sp) # fetch s1
	addi $sp, $sp, 4 # move stack pointer
	lw $s0, 0($sp) # fetch s0
	addi $sp, $sp, 4 # move stack pointer
	lw $ra, 0($sp) # fetch return address
	addi $sp, $sp, 4 # move stack pointer

	
	jr $ra
	
	
