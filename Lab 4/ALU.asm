# Number used for t0 = 0x0123456
# The number changed is the t1

.data

.text

main:
	li t0, 0x01234567
	li t1, 0x11223344
	add s0, t0, t1		# testing add function
	
<<<<<<< HEAD
=======
	addi s1, t0, 0x00000010	# testing addi function
	
>>>>>>> 3f5de12a1e25dff96678ddddf61d4b94892e9b66
	li t1, 0x11223344
	sub s2, t0, t1		# testing sub function
	
	li t1, 0x00000001
	sll s3, t0, t1		# testing shift left function
	
	li t1, 0x00000001
<<<<<<< HEAD
	srl s4, t0, t1		# testing shift right function
	
	li t1, 0x11223344
	and s5, t0, t1		# testing and function
=======
	srl s3, t0, t1		# testing shift right function
	
	li t1, 0x11223344
	and s4, t0, t1		# testing and function
	
	andi s5, t0, 0x00000010	# testing andi function
>>>>>>> 3f5de12a1e25dff96678ddddf61d4b94892e9b66
	
	li t1, 0x11223344
	or s6, t0, t1		# testing or function
	
<<<<<<< HEAD
	li a7, 10
	ecall
=======
	ori s7, t0, 0x00000010	# testing ori function
	
	li a7, 10
	ecall
>>>>>>> 3f5de12a1e25dff96678ddddf61d4b94892e9b66