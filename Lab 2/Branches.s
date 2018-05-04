# Lab 2 Part 2 - Branches

    .data   # Data declaration section

varA:   .word   10
varB:   .word   15
varC:   .word   4
varZ:   .word   1

    .text

main:       # Start of code section
    
    # Read variables from memory to registers
    lw  s0, varA        # Load A
    lw  s1, varB        # Load B
    lw  s2, varC        # Load C
    lw  s3, varZ        # Load Z

	# If statement
	blt s0, s1, One		# if(A < B) go to one
	blt s1, s0, Three	# if(A > B) go to three
	addi t1, s2, 1		# Store C+1 in t1 to compare
	addi t2, x0, 7		# Store 7 into t2
	beq t1, t2, Three	# if((C+1) == 7) go to three
	sw s3, 3			# Else z = 3
	j Switch			# Jump to Switch
One:
	addi t3, x0, 5		# Store 5 into t3
	blt t3, s2, Two		# 5 < C go to Two
Two:
	li s3,1			# Store z = 1
	j Switch			# Jump to Switch
Three:
	li s3, 2			# Store z = 2
	j Switch			# Jump to Switch
	
	# Switch
Switch:
	addi t1, x0, 1
	bne s3, t1, Default
	li s3, -1
	j End
	addi t4, x0, 2		# Store 7 into t4
	bne s3, t4, Default
	li s3, -2
	j End
	addi t5, x0, 3		# Store 3 into t5
	bne s3, t4, Default
	li s3, -3
	j End
Default:
	li s3, 0
	j End
	
    # Store register value to memory variable
End:
    sw  s0, varA, t0
    sw  s1, varB, t0
    sw  s2, varC, t0
    sw  s3, varZ, t0
	
    # Print value stored in Z
    li  a7, 1 			# print integer
    lw  a0, varZ
    ecall
	
    li  a7,10       #system call for an exit
    ecall

# END OF PROGRAM
