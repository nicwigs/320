.text
.global get_bit

@
@ r0 - Array of integers
@ r1 - Size of the array
@ r2 - Desired bit
@
get_bit:
	@r0 = #data
	@r1 = size
	@r2 = desired
	stmfd sp!,{r4-r8, lr}

	lsr r4,r2,#5		@r4 = desired bit / 32
	cmp r4,r1			@desired/32 > size?
	bge out_of_range	
	cmp r4,#0			@desired/32 < 0
	blt out_of_range

	and r2,r2,#31		@r2 % 32
	mov r7,#31
	sub r2,r7,r2		@reverse since counting starts at highest order bit 

	lsl r4,r4,#2		@desired word * 4 to get address
	ldr r6,[r0,r4]		@r6 is desired word 

	mov r5,#1			@bit shifter
	lsl r5,r5,r2		@shift from the number of bits above

	ands r5,r6			@and shifter and word
	movne r0,#1			@and is not 0, so its a 1!
	bne return 			@finish, if was 0, will continue to out_of_range then return 

out_of_range:
	mov r0,#0			@return 0

return:
	ldmfd sp!,{r4-r8,lr}
	bx lr



    
    

