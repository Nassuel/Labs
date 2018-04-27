#Function Call

	.data

a:	.word	0
b:	.word	0
c:	.word	0

	.text
main:
	addi	t0,x0,5		# i = 5
	addi	t1,x0,10	# j = 10
	addi	sp,sp,-8	# allocate memory
	sw	t0,0(sp)	# store 5 in stack
	sw	t1,4(sp)	# store 10 in stack
	jal	addItUp		# go to function
	
	sw	a0,a,t6
	lw 	s3, a
	#addi	sp, sp, 4
	
	lw	t1,4(sp)
	sw	t1,0(sp)	#store 10 in stack
	jal 	addItUp		#go to function
	
	sw	a0,b,t6
	lw 	s4, b
	#addi	sp, sp, 4
	
	add 	t5, s3, s4	#c = a+b
	sw 	t5, c, t6
	
    	li  	a7, 1		# print integer
    	lw  	a0, c
    	ecall
	li  	a7,10		#system call for an exit
    	ecall

addItUp:
	lw	a2, 0(sp)	#load 5 into register
	addi 	t0, zero, 0	#x = 0
	addi	t1, zero,0	#i = 0
	j forLoop
	
forLoop:
	add	t0, t0, t1	# x = x + i
	addi	t0, t0, 1	# x = x + 1
	addi	t1, t1, 1	# i++
	blt	t1, a2, forLoop
	add	a0, zero,t0	#store final x into return register a0
	ret

