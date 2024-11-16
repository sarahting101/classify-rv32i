# Assignment 2: Classification

## ReLU Implementation

The task is to implement the Rectified Linear Unit (ReLU) function by modifying the input values of an array.

### Implementation Method

A loop iterates through the array. For each element:
- If the number is positive, the loop proceeds to the next element.
- If the number is negative, it is set to zero.

### Notes

- There are two potential methods for implementation:
1. The approach described above, where we directly modify negative values.
2. An alternative approach where negative numbers are passed to a separate function for modification. However, this approach proved to be more complicated, as it required additional functions for handling negative values.
- handle error
  ```assembly=
  error:
    li a0, 36          
    j exit 
    
  exit:
    mv a1, a0    # move to a1 for system call
    li a0, 17    # 17: exit the program
    ecall
  ```
---

## ArgMax Implementation

The goal is to find the first occurrence of the maximum element in an array.

### Implementation Method

A loop iterates through the array:
- If a number is less than the current maximum, it skips to the next iteration.
- Otherwise, it updates the current maximum value.

### Notes

- `bge` (branch if greater than or equal) and `blt` (branch if less than **not equal**) are used for comparisons.

---

## Dot Product Implementation

This function computes the strided dot product of two arrays (or matrices).

### Implementation Method

1. Calculate the stride for each matrix and access the corresponding elements for the dot product.
2. Replace the `mul` instruction with RV32I instructions only:
   - Encapsulate the `mul` operation into a separate function to simplify reusability in other parts of the code.
   - Steps:
     1. Save register values to the stack.
     2. Determine the sign of the result (positive or negative).
     3. Convert both multiplicands to positive values.
     4. Use **binary multiplication** in a loop to compute the product.
     5. Load register values from the stack.

### Notes

- After running tests, it was found that using binary multiplication resulted in a runtime reduction of approximately 30 seconds (from 89.355 to 54.179). Therefore, binary multiplication is more efficient in this context.

---

## Matrix Multiplication

This function performs matrix multiplication.

### Implementation Method

In the `inner_loop_end` function:
- The row counter is incremented by 1.
- The pointer to the first matrix is moved to the next row's starting address.

---

## Read Matrix and Write Matrix Implementation

This functionality reads or writes a binary matrix from/to a file and loads it into memory.

### Implementation Method

The `mul` instruction is replaced with the function created earlier to handle multiplication.

---

## Classification Implementation

This section integrates all the previous components to classify an input using two weight matrices, along with the ReLU and ArgMax functions.

### Implementation Method

The four instances of the `mul` instruction are replaced by the previously implemented multiplication function.




