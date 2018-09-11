.text
.global rule30


@
@ rule30 iteration calculator
@ r0 - int *cells
@ r1 - int size
@
rule30:
	stmfd sp!,{r4-r10,lr} @push registers 

	cells .req r4 		@alias for r4, hold given cell array 
	size .req r5		@alias for r5, size of original cell array 

	mov cells,r0 		@copy cell pointer
	mov size,r1 		@copy size

	mov r0,size			@r0 = size
	mov r1,#4			@size of int is 4 bits
	bl calloc			@allocate

	cells2 .req r6		@alias for r6, holder of new bits 
	mov cells2,r0 		@copy over allocated memory

	j .req r7			@alias for r7--word index
	mov j,#0			@start word index at 0

	code .req r10 		@3 bit code alias

	i .req r9			@THE absolute index of bit, goes past 31.....just keeps going 
	mov i,#0			@ i = 0


wordLoop:				@loop through the words in cells array 
	cmp j,size			@compare index value with size 
	bge wordLoopEnd 	@j >= size leave 

bitLoop:				@loop though the bits in current word 
						@condition at bottom, checks if the mod of index is 31, if so it leaves this loop
						@cant check right here since if it was bit 32 aka first bit out of range of the 
						@current word, then the mod would be 0. But that is an exceptable value!
						@0 if the first index of the word!
						@So i thought this was the best approach .

gettingBits:			@this section grabs the desired bits from cells array 
	mov r0,cells 		@array 
	mov r1,size 		@size of arrray 
	sub r2,i,#1			@desired index 
	bl get_bit 			@Ex 1

	lsl r0,r0,#2		@shift 1st bit 2 places -> 100
	mov code,#0			@start off at 0
	mov code,r0 		@ex. goes 000 to 100

	mov r0,cells 		@array 
	mov r1,size			@size of array 
	mov r2,i 			@new index  
	bl get_bit 	 		@ex. 1

	lsl r0,r0,#1		@shift 2nd bit 1 place -> 10
	orr code,code,r0    @100 + 10 -> 110 

	mov r0,cells 		@array 
	mov r1,size			@size of array 
	add r2,i,#1			@new index 
	bl get_bit 			@Ex. 0

	orr code,code,r0    @ becomes 110 

setCode: 				@this branch finds the setto val 
	cmp code,#0			@000
	moveq r3,#0 		@r3 holds setto val 
	beq settingBits 	@jump 

	cmp code,#4			@001,010,011,100 all 1 
	movle r3,#1 		@setto in r3 
	ble settingBits 	@jump 

	mov r3,#0			@101,110,111 all 0

settingBits: 			@this calls setbit to set the new value 
	mov r0, cells2 		@array 
	mov r1,size			@size of array cells2
	mov r2,i 			@deisred bit 
	mov r3,r3 			@non-zero to set 
	bl set_bit 			@actually sets the bit @ STORES IT!

bitLoopCondition:
	and r0,i,#31		@i % 32, since i keeps counting up 
	cmp r0,#31			@if bit = 31,leave 
	add i,#1			@i ++, either way add 1 to i 
	bne bitLoop 		@not last index, Keep Looping!!!!!!			

bitLoopEnd: 			@if this past index was 31 then done with this word! so leave 
	add j,#1			@cell index ++
	b wordLoop 			@loop!

wordLoopEnd:			@new values made! Time to copy over!
	mov j,#0 			@r0 is index count 

copyOver:				@copies over new values 

	cmp j,size 		
	bge done			@index >= size you are done

	lsl i,j,#2			@what will be used to add to the adresses 4*index 

	ldr r8,[cells2,i]   @r2 is new word 
	str r8,[cells,i]	@store in correct location 

	add j,#1			@k++ 
	b copyOver 			@loop!!!


done:
	mov r0,cells2 		@set up to free
	bl free 			@free memory 
	ldmfd sp!,{r4-r10,lr}
	bx lr

	.unreq cells
	.unreq size
	.unreq cells2
	.unreq j  
	.unreq i
	.unreq code 
