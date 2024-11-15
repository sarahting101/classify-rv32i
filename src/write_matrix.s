.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Write a matrix of integers to a binary file
# FILE FORMAT:
#   - The first 8 bytes store two 4-byte integers representing the number of 
#     rows and columns, respectively.
#   - Each subsequent 4-byte segment represents a matrix element, stored in 
#     row-major order.
#
# Arguments:
#   a0 (char *) - Pointer to a string representing the filename.
#   a1 (int *)  - Pointer to the matrix's starting location in memory.
#   a2 (int)    - Number of rows in the matrix.
#   a3 (int)    - Number of columns in the matrix.
#
# Returns:
#   None
#
# Exceptions:
#   - Terminates with error code 27 on `fopen` error or end-of-file (EOF).
#   - Terminates with error code 28 on `fclose` error or EOF.
#   - Terminates with error code 30 on `fwrite` error or EOF.
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    # save arguments
    mv s1, a1        # s1 = matrix pointer
    mv s2, a2        # s2 = number of rows
    mv s3, a3        # s3 = number of columns

    li a1, 1

    jal fopen

    li t0, -1
    beq a0, t0, fopen_error   # fopen didn't work

    mv s0, a0        # file descriptor

    # Write number of rows and columns to file
    sw s2, 24(sp)    # number of rows
    sw s3, 28(sp)    # number of columns

    mv a0, s0
    addi a1, sp, 24  # buffer with rows and columns
    li a2, 2         # number of elements to write
    li a3, 4         # size of each element

    jal fwrite

    li t0, 2
    bne a0, t0, fwrite_error

    # mul s4, s2, s3   # s4 = total elements
    # FIXME: Replace 'mul' with your own implementation
	
	
	addi sp, sp, -12
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw t0, 8(sp)
	#sw t1, 12(sp)
	#sw t2, 16(sp)
	#sw t3, 20(sp)
	#sw t5, 24(sp)
	
	add a0, x0, s2
	add a1, x0, s3
	
	
	j mul_rv32i
	
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
	j mul_s4
	
	

mul_s4:
	mv s4, t2

	lw a0, 0(sp)
	lw a1, 4(sp)
	lw t0, 8(sp)
	#lw t1, 12(sp)
	#lw t2, 16(sp)
	#lw t3, 20(sp)
	#lw t5, 24(sp)
	addi sp, sp, 12
	
	# mul_end


    # write matrix data to file
    mv a0, s0
    mv a1, s1        # matrix data pointer
    mv a2, s4        # number of elements to write
    li a3, 4         # size of each element

    jal fwrite

    bne a0, s4, fwrite_error

    mv a0, s0

    jal fclose

    li t0, -1
    beq a0, t0, fclose_error

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 44

    jr ra

fopen_error:
    li a0, 27
    j error_exit

fwrite_error:
    li a0, 30
    j error_exit

fclose_error:
    li a0, 28
    j error_exit

error_exit:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 44
    j exit
