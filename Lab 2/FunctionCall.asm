#Function Call

.data

a:	.word	0
b:	.word	0
c:	.word	0

.text
main:

lw	s0,a
lw	s1,b
lw	s2,c

addi	t0,zero,5	#i
addi	t1,zero,10	#j

mv	a0,t0 
mv	a1,t0
jal	sum

addItUp: 
addi	sp,sp,-4
sw	s1, 4(sp)
sw	s0, 0(sp)

	
	