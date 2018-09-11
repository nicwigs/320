.text
.global set_bit

@
@ r0 - Array of integers
@ r1 - Size of the array
@ r2 - Desired bit
@ r3 - Non-zero to set
@
set_bit:
	@r0 = *data
	@r1 = size
	@r2 = desired bit
	@r3 = setto 	
	stmfd sp!,{r4-r8,lr}

	lsr r4,r2,#5		@r4 = desired bit / 32
	cmp r4,r1			@desired/32 > size?
	bge out_of_range	

	and r2,r2,#31		@r2 % 32
	mov r7,#31
	sub r2,r7,r2		@reverse since counting starts at highest order bit 

	lsl r4,r4,#2		@desired word * 4 to get address
	ldr r6,[r0,r4]		@r6 is desired word 

	mov r5,#1			@bit shifter
	lsl r5,r5,r2		@shift from the number of bits above

	movs r3,r3			@flags on setto value

	beq setto_0

	orr r6,r6,r5		@if not zero!
	str r6,[r0,r4]
	b return 

setto_0:
	bic r6,r6,r5
	str r6,[r0,r4]
out_of_range:
	
return: 
	
	ldmfd sp!,{r4-r8,lr}
	bx lr


    
    
