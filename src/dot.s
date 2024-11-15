.globl dot

.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0            
    li t1, 0         
	
	li t6, 2
	# mul t5, a3, t6	#t5=a1 stride
	sll t5, a3, t6

	# mul t6, a4, t6	#t6=a2 stride
	sll t6, a4, t6
	

loop_start:
    # TODO: Add your own implementation
    lw t2, 0(a0)	#t2=a0[]
    lw t3, 0(a1)	#t3=a1[]
    # mul t4, t2, t3
	
	addi sp, sp, -28
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw t0, 8(sp)
	sw t1, 12(sp)
	sw t2, 16(sp)
	sw t3, 20(sp)
	sw t5, 24(sp)
	
	add a0, x0, t2
	add a1, x0, t3
	
	
	j mul_rv32i
	
	
mul_t4:
	mv t4, t2

	lw a0, 0(sp)
	lw a1, 4(sp)
	lw t0, 8(sp)
	lw t1, 12(sp)
	lw t2, 16(sp)
	lw t3, 20(sp)
	lw t5, 24(sp)
	addi sp, sp, 28
	
	# mul_end
	add t0, t0, t4
    addi a2, a2, -1
    bge t1, a2, loop_end
	
	add a0, a0, t5
	add a1, a1, t6
    j loop_start
	
mul_rv32i:
	beq a0, x0, mul_end
	beq a1, x0, mul_end
	li t2, 0		#result
	xor t3, a0, a1	#signed
	bge a0, x0, positive_a0
	sub t0, x0, a0	#make a0 positive
	j check_a1
	
positive_a0:
	mv t0, a0
	
check_a1:
	bge a1, x0, positive_a1
	sub t1, x0, a1	#make a1 positive
	j mul_loop
	
positive_a1:
	mv t1, a1
	
mul_loop:
	beq t1, x0, mul_end
	andi t5, t1, 1
	beq t5, x0, skip_add
	add t2, t2, t0
	
skip_add:
	slli t0, t0, 1
	srli t1, t1, 1
	j mul_loop
	
mul_end:
	bge t3, x0, mul_fin
	sub t2, x0, t2

mul_fin:
	j mul_t4
	
	
	
	
	

	


loop_end:
    mv a0, t0   #t0=result
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit
    
exit:
    li a7, 10
    ecall
