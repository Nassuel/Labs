#Function Call

	.data

a:	.space	4
b:	.space	4
c:	.space	4

	.text
main:

	lw	s0,a
	lw	s1,b
	lw	s2,c

	addi	t0,x0,5		# i = 5
	addi	t1,x0,10	# j = 10
	mv	a2,t0
	jal	addItUp
	
	sw	a0,a,t6
	lw 	s3, a
	
	mv	a2,t1
	jal addItUp
	
	sw	a0,b,t6
	lw 	s4, b
	
	add 	t5, s3, s4
	
	sw 	t5, c, t6
	
	# Print value stored in Z
    	li  	a7, 1 			# print integer
    	lw  	a0, c
    	ecall
	
	li  	a7,10       #system call for an exit
    	ecall

addItUp:
	addi 	sp, sp, -4
	sw	a2, 0(sp)
	sub 	a0, a0, a0	# x = 0
	sub 	a2, a2, a2
	j forLoop
	
forLoop:
	add a0, a0, a2	# x = x + i
	addi a0, a0, 1	# x = x + 1
	lw t6, 0(sp)
	addi a2, a2, 1	# i++
	blt a2, t6, forLoop
	addi sp, sp, 4
	ret

