# Lab 2 Part 4 - Arrays

    .data   # Data declaration section

aArray:   .space   20
bArray:   .word    1, 2, 4, 8, 16  

    .text

main:       # Start of code section
    
    # Read variables from memory to registers
    li  t1, 0        	# Load variable 
    la 	s1, aArray		# Load A array reference into s0
    la 	s0, bArray		# Load B into s0
    
    # For loop
    forLoop: slti t0, t1, 5
    beq t0, x0, END
    slli t2, t1, 2
    add t3, t2, s0
    lw t4, 0(t3)
    addi t4, t4, -1
    slli t5, t1, 2
    add t6, t5, s1
    sw 	 t4, 0(t6)
    addi t1, t1, 1
    j forLoop
END:
    addi t1, t1, -1
    li s3, 2
While:	slti t0, t1, 0
    bne t0, x0, END1
    slli t2, t1, 2
    add t2, t2, s1
    lw t3, 0(t2)
    slli t4, t1, 2
    add t4, t4, s0
    lw t5, 0(t4)
    add t5, t5, t3
    mul t5, t5, s3
    sw t5, 0(t2)
    addi t1, t1, -1
    j While
END1:
    li  a7,10       #system call for an exit
    ecall