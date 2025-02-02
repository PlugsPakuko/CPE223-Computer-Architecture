.global main
.section .note.GNU-stack,"",%progbits @ Tell the system that there is no executable stack

.section .data
.LC0:
    .asciz  "Fibonacci number at %d position: %d\n"    @ Format string for printf

.section .text
fibonacci:
    PUSH {R4, R5, LR} @New stack 

    CMP R0, #1
    BEQ base_case
    CMP R0, #0
    BEQ base_case

    @ Compute fib(n-1)
    SUB R0, R0, #1
    PUSH {R0}
    BL fibonacci
    MOV R4, R0
    POP {R0}

    @ Compute fib(n-2)
    SUB R0, R0, #1
    PUSH {R4}
    BL fibonacci
    MOV R5, R0
    POP {R4}
    ADD R0, R4, R5 

    POP {R4, R5, LR} @Restore stack
    BX LR

base_case:
    MOV R0, R0
    POP {R4, R5, LR}
    BX LR

main:
    MOV R0, #12
    PUSH {R0}
    BL fibonacci   

    @ Print result
    MOV R2, R0
    POP {R0}
    MOV R1, R0           
    LDR R0, =.LC0  
    BL printf

    MOV R7, #1           @ syscall: exit
    SVC 0                @ Call kernel
