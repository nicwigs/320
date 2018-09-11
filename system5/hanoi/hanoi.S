.text
.global main

main:
	stmfd sp!,{r4-r8,lr} 		@save r4,lr on the stack

	mov r4,#0					@initalize num

	@ printf("Enter the number of disks : ");
	ldr r0,=inputMsg 
	bl printf					

	@ fgets(buffer,sizeof(buffer),stdin)
	ldr r0,=buffer 				@argument 1: buffer address
	ldr r1,=BUFFERSIZE			@Argument 2: size of the buffer
	ldr r2,=stdin				@Adress of stdin variable in memory
	ldr r2,[r2]					@Argument 3: value of stdin
	bl fgets

	@ num = atoi(buffer)
	ldr r0,=buffer 
	bl atoi
	mov r4,r0					@store num in r4 so dont loose it 

	@if(num < 1)
	cmp r4,#1					@see if less than 1
	blt impossibleCase

	@ printf("The moves to solve the Tower of Hanoi are :\n");
	ldr r0,=movesMsg
	bl printf

	@towers(num, 1, 2, 3);
	mov r0,r4 					@first arg is num
	mov r1,#1
	mov r2,#2
	mov r3,#3
	bl towers 					@call recusive function

	mov r0,#0					@return 0
	b done

impossibleCase:
	@ printf("Towers of Hanoi makes no sense with %d disks\n", num);
	mov r1,r4 					@2nd arg is num
	ldr r0,=impossibleMsg		@1st arg is string
	bl printf	

	mov r0,#1					@return 1

done:
	ldmfd sp!,{r4-r8,lr}		@restore r4,lr from the stack	
  	bx lr

@@@@@@@@@@@@ towers function @@@@@@@@@@@@@

towers:
	stmfd sp!,{r4-r8,lr} 		@save r4,lr on the stack

	cmp r0,#1					@compare with 1
	beq base
	
	mov r4,r0					@copy num 
	mov r5,r1					@copy frompeg
	mov r6,r2					@copy topeg
	mov r7,r3					@copy auxpeg

	@towers(num - 1, frompeg, auxpeg, topeg);
	sub r0,r4,#1				@num -1
	mov r1,r5					@2nd arg gets frompeg 		
	mov r2,r7					@3rd arg gets auxpeg
	mov r3,r6					@4th arg gets topeg
	bl towers 

	@printf("Move disk %d from peg %d to peg %d\n", num, frompeg, topeg);
	ldr r0,=manyTowerMsg
	mov r1,r4  					@2nd arg num 
	mov r2,r5					@3rd arg frompeg
	mov r3,r6					@4th arg topeg 
	bl printf

	@towers(num - 1, auxpeg, topeg, frompeg);
	sub r0,r4,#1				@num -1
	mov r1,r7					@2nd arg gets auxpeg		
	mov r2,r6					@3rd arg gets topeg
	mov r3,r5					@4th arg gets frompeg
	bl towers 

	b towers_done				@done!

base:
	ldr r0,=singleTowerMsg		@1st arg string, 2nd and 3rd alrady in right locations
	bl printf
 
towers_done:
	ldmfd sp!,{r4-r8,lr}		@restore r4,lr from the stack
	bx lr						@goes to function that called it

@@@@@@@@@@@@@@@@@@@@@@@@@ data @@@@@@@@@@@@@@@@@@@@@@@@@@@
.data

inputMsg:
	.asciz "Enter the number of disks : "
impossibleMsg:
	.asciz "Towers of Hanoi makes no sense with %d disks\n"
movesMsg:
	.asciz "The moves to solve the Tower of Hanoi are :\n"
singleTowerMsg:
	.asciz "Move disk 1 from peg %d to peg %d\n"
manyTowerMsg:
	.asciz "Move disk %d from peg %d to peg %d\n"

.set BUFFERSIZE,100

buffer:
	.space BUFFERSIZE,0
