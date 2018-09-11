@
@ Text section
@

.text

.global main

@
@ main(argc, argv)
@ r0: The number of arguments
@ r1: Pointer to an array of string pointers
@ 
main:
	stmfd sp!,{r4-r8,lr}				@push
	
	@if arcv < 2
	cmp r0,#2					@compare argc to 2
	bge args_ok					@Branch if argc >=2....this is the else 

	ldr r0,=usage 				@Get address of message
	bl printf					@printf

	mov r0,#1					@return value = 1
	b main_return				@return 

args_ok:
	ldr r0,[r1,#4] 				@get argv[1]
	bl atoi						@convert to integer 

	@mov r1,r0					@integer to r1
	@ldr r0,=test				@"%d\n"
	@bl printf					@printf

	cmp r0,#2					@compare size to 2
	bge size_ok					@Branch if size >=2

	ldr r0,=minsize				@get adress of message
	bl printf					@printf

	mov r0,#1					@return value = 1
	b main_return				@return

size_ok:
	size .req r4 				@Use r4 for size, size = alias for r4 
	mov size,r0					@size wont get destroyed

	add r0,size,#1				@r0 = size + 1
	mov r1,#4					@size of integer
	bl calloc					@calloc

	@mov r6,#1					@checks display function 
    @str r6,[r0,#12] @ sieve[3]
    @str r6,[r0,#20] @ sieve[5]

	sieve .req r5				@alias for r5 is sieve
	mov r5,r0					@save the result

	mov r0,sieve 
	mov r1,size 
	bl intialize				@initalize(sieve,size)

	mov r0,sieve 
	mov r1,size 
	bl sieve_it					@sieve_it(sieve,size)

	mov r0,sieve 				
	mov r1,size
	bl display 					@display(seive,size)


	mov r0,sieve
	bl free						@free memory 

	mov r0,#0
	
main_return:
	ldmfd sp!,{r4-r8,lr}				@pop
	bx lr

	.unreq size 				@undo alias
	.unreq sieve 				@unfo alias
@
@ display(int *sieve,int size)
@
display:
	stmfd sp!,{r4-r8,lr}

	size .req r4 				@use r4 for size
	sieve .req r5				@use r5 for sieve

	mov sieve,r0
	mov size,r1

	ldr r0,=primesmsg 			@load message adress
	bl printf					@printf

	i .req r6					@i is r6
	mov i,#2					@set i = 2

display_loop:
	cmp i,size 					
	bgt display_loop_end		@if i>size leave

	lsl r7,i,#2					@i*4
	ldr r0,[sieve,r7]			@sieve[i]

	cmp r0,#0					@==0?
	beq display_skip			@yes, skip 

	ldr r0,=number
	mov r1,i
	bl printf					@printf(" %d",number)

display_skip:
	add i,#1					@i++
	b display_loop 				@continue loop

display_loop_end:
	ldr r0,=end					@load message address
	bl printf

display_return:
	ldmfd sp!,{r4-r8,lr}
	bx lr

	.unreq sieve 				@undo alias 
	.unreq size
	.unreq i
@
@ initalize (sieve, size)
@
intialize:
	stmfd sp!,{r4-r8,lr}

	size .req r4 				@use r4 for size
	sieve .req r5				@use r5 for sieve

	mov sieve,r0				@copy over sieve 
	mov size,r1					@copy over size 

	i .req r6					@i is r6
	mov i,#2					@set i = 2

initalize_loop:
	cmp i,size 					
	bgt initialize_return 		@i > size done 

	lsl r7,i,#2					@i*4
	mov r0,#1					
	str r0,[sieve,r7]			@seive[i] = 1

	add i,#1					@i++
	b initalize_loop 			@continue loop 

initialize_return:
	ldmfd sp!,{r4-r8,lr}
	bx lr

	.unreq sieve 				@undo alias 
	.unreq size
	.unreq i 
@
@sieve_it(int *sieve, int size)
@
sieve_it:
	stmfd sp!,{r4-r8,lr}

	size .req r4 				@use r4 as size
	sieve .req r5 				@use r5 as sieve

	mov sieve,r0				@copy into sieve
	mov size,r1 				@copy into size

	i .req r6					@i is r6
	mov i,#2					@i = 2

	j .req r7

	half .req r8 				@this is size/2
	lsr half,size,#1			@half = size/2

sieve_it_outer_loop:
	cmp i,half		
	bgt sieve_it_return 		@i > size/2 done! 

	lsl j,i,#1					@j = 2 * i

sieve_it_inner_loop:
	cmp j,size
	bgt sieve_it_inner_loop_end	@j > size leave inner loop 

	lsl r3,j,#2					@j*4
	mov r0,#0
	str r0,[sieve,r3]			@sieve[j] = 0

	add j,i 					@j+=i 
	b sieve_it_inner_loop 		@contiune loop 

sieve_it_inner_loop_end:
	add i,#1					@i ++
	b sieve_it_outer_loop		@continue loop 

sieve_it_return:
	ldmfd sp!,{r4-r8,lr}
	bx lr

	.unreq sieve 				@undo alias 
	.unreq size
	.unreq i 
	.unreq j
	.unreq half 
@
@ Data Section
@
.data 

usage: .asciz "Usage: sieve <size>\n";
minsize: .asciz "Sieve size must be at least 2\n"
primesmsg: .asciz "Primes:"
end: .asciz "\n"
number: .asciz " %d"
@test: .asciz "%d\n"
