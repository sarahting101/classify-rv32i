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
	
	li t6, 4
	mul t5, a3, t6	#t5=a1 stride
	mul t6, a4, t6	#t6=a2 stride

loop_start:
    # TODO: Add your own implementation
    lw t2, 0(a0)	#t2=a0[]
    lw t3, 0(a1)	#t3=a1[]
    mul t4, t2, t3
	add t0, t0, t4
    addi a2, a2, -1
    bge t1, a2, loop_end
	
	add a0, a0, t5
	add a1, a1, t6
    j loop_start


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
