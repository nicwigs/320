@
@ Text Section
@
.text
.global main

@
@ main(argc,argv)
@ r0: The number of arguments
@ r1: Pointer to an array of string pointers
@
main:
	stmfd sp!,{r4-r8,lr} 		@save r4,lr on the stack

	cmp r0,#2			@did the user provide an argument?
	blt usage

	@determine the number of the guess
	add r1,#4			@Move to the second string
	ldr r0,[r1]			@Get the pointer to the actual string
	bl atoi				@convert to an integer
	mov r4,r0			@save the inital guess 
	@
	@ splash
	@
	mov r1,r0
	ldr r0,=splash
	bl printf			@same as printf("we are guessing the number %d\n",num);
loop:
						@fgets(buffer,sizeof(buffer),stdin)
	ldr r0,=buffer 		@argument 1: buffer address
	ldr r1,=BUFFERSIZE	@Argument 2: size of the buffer
	ldr r2,=stdin		@Adress of stdin variable in memory
	ldr r2,[r2]			@Argument 3: value of stdin
	bl fgets

	@
	@ Convert to an integer
	@
	ldr r0,=buffer
	bl atoi

	@test it 
	cmp r0,r4
	blt toolow
	bgt toohigh

	mov r1,r0			@move correct answer over to second argument
	ldr r0,=rightmsg
	bl printf
	
  	mov r0,#0
done:
	ldmfd sp!,{r4-r8,lr}		@restore r4,lr from the stack
  	bx lr

usage:
	ldr r0,=usagemsg
	bl printf
	b done
toolow:					@guess was too low
	ldr r0,=lowmsg
	bl printf
	b loop
toohigh:				@guess was too high
	ldr r0,=highmsg
	bl printf
	b loop

@
@ Data Section
@
.data 

@
@Messages
@
usagemsg:
	.asciz "Usage: guess [number]\n"
splash:
	.asciz "We are guessing the number %d\n"
highmsg:
	.asciz "Your guess was too high!\n"
lowmsg:
	.asciz "Your guess was too low\n"
rightmsg:
	.asciz "You guessed the number %d\n"

@
@Input buffer
@
.set BUFFERSIZE,100

buffer:
	.space BUFFERSIZE,0
