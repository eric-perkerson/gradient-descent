// 64-bit ARM assembly code for Apple silicon (M1 chip)
// Gradient descent algorithm for finding argmin(f) where 
//     f(x) = 2x^4 + 3x^2 + x + 4

// Gradient descent update step: x = x - alpha*f'(x)
// where f'(x) = 8x^3 + 6x + 1

// Parameter values: alpha = 3.14e-2
//                   max_iter = 100


.data
.align 4
alpha: 
    .double 3.14e-2
prtstr: 
    .asciz "x = %f\n"
.align 4


.text
.align 4
.global _main
_main:
    adrp x0, prtstr@PAGE
    add x0, x0, prtstr@PAGEOFF
    adrp x1, alpha@PAGE
    add x1, x1, alpha@PAGEOFF

    fmov d0, #0         // Sets x = 0
    ldr d1, [x1]        // d1 holds alpha
    fmov d2, #1         // Initialize constants
    fmov d3, #6         // Initialize constants
    fmov d4, #8         // Initialize constants
    mov w2, #100        // Set i = max_iter
loop:
    fmul d5, d0, d3     // Store 6x
    fmul d6, d0, d0     // x^2
    fmul d6, d6, d0     // x^3
    fmul d6, d6, d4     // 8x^3
    fadd d6, d6, d5     // 8x^3 + 6x
    fadd d6, d6, d2     // 8x^3 + 6x + 1
    fmul d6, d6, d1     // alpha*(8x^3 + 6x + 1)
    fsub d0, d0, d6     // x = x - alpha*(8x^3 + 6x + 1)
    subs w2, w2, #1     // i = i - 1
    b.ne loop           // branch until i = 0

    str	d0, [SP, #-16]! // Push value of x onto stack
    bl _printf          // Call printf to print x
    add sp, sp, #16     // Clean up stack
    mov X0, #0          // Set exit code 0
    mov X16, #1         // System call number 1 terminates the program
    svc #0x80           // Call kernel to terminate program


