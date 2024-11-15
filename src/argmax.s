.globl argmax

.text
# =================================================================
# FUNCTION: Maximum Element First Index Finder
#
# Scans an integer array to find its maximum value and returns the
# position of its first occurrence. In cases where multiple elements
# share the maximum value, returns the smallest index.
#
# Arguments:
#   a0 (int *): Pointer to the first element of the array
#   a1 (int):  Number of elements in the array
#
# Returns:
#   a0 (int):  Position of the first maximum element (0-based index)
#
# Preconditions:
#   - Array must contain at least one element
#
# Error Cases:
#   - Terminates program with exit code 36 if array length < 1
# =================================================================
argmax:
    li t6, 1
    blt a1, t6, handle_error

    lw t0, 0(a0)    #t0=max

    #li t1, 0        #t1=max_index
    add t1, a1, x0
    li t2, 1
    add t4, a1 , x0
loop_start:
    # TODO: Add your own implementation
    lw t3, 0(a0)
    blt t3, t0, not_max
    beq t3, t0, not_max
    add t0, t3 , x0
    add t1, a1 , x0
    
not_max:
    addi a0, a0, 4
    addi a1, a1, -1
    bne a1, x0, loop_start
    sub t1, t4, t1
    add a0, t1 , x0
    ret

handle_error:
    li a0, 36
    j exit

exit:
	mv a1, a0
	li a0, 17
	ecall
