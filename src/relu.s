.globl relu

.text
# ==============================================================================
# FUNCTION: Array ReLU Activation
#
# Applies ReLU (Rectified Linear Unit) operation in-place:
# For each element x in array: x = max(0, x)
#
# Arguments:
#   a0: Pointer to integer array to be modified
#   a1: Number of elements in array
#
# Returns:
#   None - Original array is modified directly
#
# Validation:
#   Requires non-empty array (length ≥ 1)
#   Terminates (code 36) if validation fails
#
# Example:
#   Input:  [-2, 0, 3, -1, 5]
#   Result: [ 0, 0, 3,  0, 5]
# ==============================================================================
relu:
    li t0, 1             
    blt a1, t0, error     
    li t1, 0             
    
    mv t2, a0

loop_start:
    # TODO: Add your own implementation
    lw t3, 0(t2)
    bge t3, t1, greater_than_zero
    sw t1, 0(t2)
    
greater_than_zero:

    addi t2, t2, 4
    addi a1, a1, -1
    bne a1, x0, loop_start
    ret
    
error:
    li a0, 36          
    j exit 
    
exit:
	mv a1, a0
	li a0, 17
	ecall
