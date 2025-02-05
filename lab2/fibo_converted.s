	.arch armv7-a
	.fpu vfpv3-d16
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"fibo.c"
	.text
	.align	1
	.global	fibonacci
	.syntax unified
	.thumb
	.thumb_func
	.type	fibonacci, %function

fibonacci: @entry function fibonacci
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r7, lr} 			@ push r4,r7,lr to current stack 
	sub	sp, sp, #12  				@ Allocate space for 3 variables * 4 bytes
	add	r7, sp, #0 					@ copy sp to r7 for tracking current stack
	str	r0, [r7, #4] 				@ store r0(input num) in r7+4 address as memory address
	ldr	r3, [r7, #4] 				@ load r7+4 address value(input num) into r3 
	cmp	r3, #1 						@ compare r3(input num) with 1 to check basecase
	bgt	.L2 			 			@ if r3 > 1 then jump to .L2
	ldr	r3, [r7, #4] 				@ load r7+4 address value(input num) into r3
	b	.L3 						@ jump to .L3 if r3 is not greater than 1

.L2: @recursive case: compute fibonacci(n-1) and fibonacci(n-2) and add them
	ldr	r3, [r7, #4] 				@ load r7+4 address value(input num) into r3
	subs	r3, r3, #1 				@ subtract 1 from r3 as n-1 in fibonacci(n-1)
	mov	r0, r3 						@ store r3(n-1) in r0 as an argument
	bl	fibonacci(PLT) 				@ recursive call to fibonacci function as r0=n-1
	mov	r4, r0 						@ store fibonacci(n-1) result in r4
	ldr	r3, [r7, #4] 				@ load r7+4 address value(input num) into r3
	subs	r3, r3, #2 				@ subtract 2 from r3 as n-2 in fibonacci(n-2)
	mov	r0, r3 						@ store r3(n-2) in r0 as an argument
	bl	fibonacci(PLT) 				@ recursive call to fibonacci function as r0=n-2
	mov	r3, r0 						@ store fibonacci(n-2) result in r3
	add	r3, r3, r4 			 		@ add fibonacci(n-1) and fibonacci(n-2) result

.L3: @base case: return itself if n<=1 and pop all current stack
	mov	r0, r3 						@ move r3 to r0 as return value
	adds	r7, r7, #12 			@ add 12 to r7 to deallocate stack
	mov	sp, r7 			 			@ move r7(current stack) to sp
	@ sp needed
	pop	{r4, r7, pc} 			 	@pop r4,r7,pc from stack to exit current state
	.size	fibonacci, .-fibonacci 
	.section	.rodata
	.align	2
.LC0: @ defining a string constant for output formatting
	.ascii	"Fibonacci(n) = %d\012\000" @ format string for output

	@ text section for main function
	.text 
	.align	1 							@ align the code
	.global	main 						@ main function
	.syntax unified  					@ Unified assembly syntax
	.thumb 								@ thumb mode for main function
	.thumb_func 						@ thumb function for main function
	.type	main, %function 			@ type of main function
main:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r7, lr} @push r7,lr Main Stack 
	sub	sp, sp, #8 					@ Allocate space for 2 variables
	add	r7, sp, #0 					@ copy sp to r7 for tracking current stack
	movs	r3, #44 		 		@ Store 44 in r3 as an argument
	str	r3, [r7]		 			@ store r3(44) in r7 as memory address
	ldr	r0, [r7]		 			@ Load r7(44) into r0
	bl	fibonacci(PLT)		 		@ Branch link to fibonacci function or Call fibonacci function
	str	r0, [r7, #4]		 		@ Store r0 (fibonacci result) in r7+4 address
	ldr	r1, [r7, #4]		 		@ Load r7+4 address value(fibonacci result) into r1
	ldr	r3, .L6		 				@ Load .LC0 address into r3 for printf

.LPIC0:  @ For the location in code to reference for printing the string
	add	r3, pc 						@ Add current location to r3
	mov	r0, r3 						@ Move r3(fibonacci result) to r0 as an argument
	bl	printf(PLT) 				@ Branch link to printf function or Call printf function
	movs	r3, #0 					@ Store 0 in r3 as an argument
	mov	r0, r3 						@ Move r3 to r0 as an argument
	adds	r7, r7, #8 				@ Add 8 to r7 to deallocate stack
	mov	sp, r7 						@ Move r7 to sp as current stack
	@ sp needed
	pop	{r7, pc} 					@pop r7,pc from stack to exit current state
.L7:
	.align	2 						@ Align the code
.L6: 
	.word	.LC0-(.LPIC0+4)   		@ Address of .LC0 for printf 
	.size	main, .-main 			@ Size of main function
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0" 		@ Compiler version
	.section	.note.GNU-stack,"",%progbits 					@ Tell the system that there is no executable stack
