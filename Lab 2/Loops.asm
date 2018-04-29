# Lab 2 Part 3 - Loops

.data

z:	.word	2
i:	.word 	0

.text
main:

for:
lw 	s0, z	
addi	t0,s0,1 
sw	t0,z,s0

addi	t1,zero,20
lw	s1,i	
blt	s1,t1,loop
beq	s1,t1,final

loop:
addi	t2,s1,2
sw	t2,i,s1
j	for

final:
lw	s0,z
addi	t0,s0,1
sw	t0,z,s0
j	do

do:
lw	s3,z
addi	t4,s3,1
sw	t4,z,t5
j	while

while:
lw	s2, z
addi	t3,zero,99
blt	s2,t3,do
beq	s2,t3,while2

while2:
lw	s4,i
lw 	s5,z
addi	t5,zero,1
bgt	s4,t5,dec
j	end

dec:
addi	t0,s4,-1
addi	t1,s5,-1
sw	t0,i,t2
sw	t1,z,t3
j	while2

end:
li  a7,10       #system call for an exit
ecall











