@You task now is to write a program in ARM assembly language that 
@will output all Armstrong numbers in the range 1 to 100000. 
@An Armstrong number is defined as a number that is equal to the sum of its digits 
@raised to the number of digits power. 
@For example, the number 153 is an Armstrong number.
@ It has three digits and 1^3 + 5^3 + 3^3 = 153.
.data
	msg1:   .asciz "\nAll Armstrong numbers between 1 and 100000:\n\n"
	msg2:	.asciz "Armstrong number: %u\n"
	db: .asciz "number %u, max %u \n"
.text

.global main

main:
	stmfd sp!,{lr}

	.equ number, 0
	.equ numdigits, 4
	.equ temp, 8
	.equ digit, 12
	.equ sum, 16
	.equ product, 20
	.equ i,24
	.equ quotient, 28
    .equ remainder, 32
	.equ size,36

	sub sp, sp, #size   	@ Allocate space

	mov r0,#1
	str r0, [sp,#number]  	@number = 1, loop inital conditon 	

	ldr r0,=msg1			@1st parameter message 
	bl printf 

range_loop:

	ldr r0, [sp,#number] 	@number
	ldr r1,=100000 
	cmp r0,r1			 
	bgt done  			 	@done if number > 10000

	ldr r0, [sp,#number] 	@number parameter 
	bl digitcounter			@call digitcounter 
	str r0, [sp,#numdigits] @store numdigits 

	ldr r0, [sp,#number]
	str r0, [sp,#temp]		@temp = number

	mov r0,#0
	str r0, [sp,#sum]		@sum = 0

temp_loop:					@while 
	ldr r0, [sp,#temp]		@temp
	cmp r0,#0
	ble check				@leave when temp <=0

	add r0, sp, #quotient 	@hidden paramter, pointer to a place to store result, address
    ldr r1, [sp,#temp]    	@numerator
    mov r2, #10			  	@denomerator 
    bl div
    ldr r0, [sp,#remainder]	@load remainder from divison
    str r0, [sp,#digit] 	@digit = temp % 10

    mov r0,#1				
    str r0, [sp,#product] 	@product = 1

    mov r0,#0				@prepare for loop 
    str r0, [sp,#i] 		@ i = 0

numdigits_loop:
	ldr r2, [sp,#i]
	ldr r1, [sp,#numdigits]
	cmp r2,r1				@if i >= numdigits, done with numdigits_loop 
	bge leave_numdigits_loop

	ldr r0, [sp,#product]
	ldr r1, [sp,#digit]
	mul r0,r0,r1 			@product * digit
	str r0, [sp,#product] 	@store new product 

	add r2,r2,#1			@i++
	str r2, [sp,#i]

	b numdigits_loop

leave_numdigits_loop:
	
	ldr r0, [sp,#sum]
	ldr r1, [sp,#product]
	add r0,r0,r1 			@sum += product
	str r0, [sp,#sum]

	add r0, sp, #quotient 	@hidden paramter, pointer to a place to store result, address
    ldr r1, [sp,#temp]    	@numerator
    mov r2, #10			  	@denomerator 
    bl div
    ldr r0, [sp,#quotient]
    str r0, [sp,#temp]		@temp /= 10 

	b temp_loop

check:
	ldr r0, [sp,#sum]
	ldr r1, [sp,#number]
	cmp r0,r1
	bne range_loop_end		@skip if sum != number

	ldr r0,=msg2			@load message
	ldr r1, [sp,#number]	@2nd parameter number
	bl printf

range_loop_end:

	ldr r0, [sp,#number]
	add r0,r0,#1			@ number ++
	str r0, [sp,#number]
	b range_loop


done:
	mov r0,#0
	add sp, sp, #size   @ Free space

	ldmfd sp!,{lr}
	bx lr
