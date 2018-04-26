# Lab 2 Part 1 - Arithmetic
.data
z:	.word	0
.text

main:

	addi	t0, zero, 15	#int A =15
	addi 	t1, zero, 10	#int B =10
	sub	t2, t0, t1	#int C =5
	addi 	t3, t2, -3	#int D =2
	addi 	t4, zero, 18	#int E=18
	sub	t5, t3, t2	#int F=-3
	
	sub	s0,t0,t1	#A-B =5
	mul	s1,t2,t3	#C*D =10
	sub	s2,t4,t5	#E-F =21
	div	s3,t0,t2	#A/C =3
	
	add	t0,s0,s1	#(A-B) + (C*D)
	add	t1,t0,s2	#[(A-B)+(C*D)]+ (E-F)
	sub	t2,t1,s3	#[(A-B)+(C*D)+(E-F)] - (A/C)
	
	sw	t2,z,t6
	
	
