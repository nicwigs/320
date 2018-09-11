.data

@
@ The Game description data structure
@
.equ    game_rows, 0
.equ    game_cols, 4
.equ    game_array,8
.equ    game_size, 12

@
@ The Game cell data structure
@ This is the contents of a location in the array
@
.equ    cell_expected, 0
.equ    cell_actual, 4
.equ    cell_size, 8

space:
	.asciz "   "
std:
	.asciz " %2d"
newLine:
	.asciz "\n"
item:
	.asciz "  %c"

.text

.global create_game
@
@ Create the game abstract data type
@ void *create_game(int rows, int cols)
@
create_game:
	push {r4-r8, lr}
	
	mov r4, r0      			@ rows
    mov r5, r1     				@ cols

    mov r0,#1					@number of such type
    mov r1,#game_size			@8 bytes
    bl calloc					@allocate @ void* calloc (size_t num, size_t size);

    @
    @Set the data stuctrure initial values
    @
    str r4,[r0,#game_rows]		@game->rows = rows
    str r5,[r0,#game_cols]		@game->cols = cols

    @ Save game pointer in a safe register
	mov r6, r0      			@ game pointer

	@
	@ Allocate the game array
	@
	mul r0,r4,r5        		@ row * cols
	mov r1,#cell_size   		@ Cell size
	bl calloc					@ void* calloc (size_t num, size_t size);

	str r0,[r6,#game_array]

	mov r0,r6

	
create_game_done:
	pop {r4-r8, lr}
	bx lr
	
	
.global destroy_game
@
@ void destroy_game(void *game)
@ Destroy the game, freeing all memory
@
destroy_game:
	push {r4, lr}

	mov r4,r0 					@save pointer to game

	ldr r0,[r4,#game_array]
	bl free 					@Free array

	mov r0,r4
	bl free 					@free game

	pop {r4, lr}
	bx lr
	
.global get_rows
@
@ Get the number of rows in the game
@ int get_rows(void *game)
@
get_rows:
	ldr r0,[r0,#game_rows]
	bx lr

.global get_cols
@
@ Get the number of columns in the game
@ int get_cols(void *game)
@
get_cols:
	ldr r0,[r0,#game_cols]
	bx lr

.global display_game
@
@ Display the game
@
display_game:
	push {r4-r10,lr}
	mov r4,r0 					@save pointer to game
	mov r5,#1					@start column index at 1

	ldr r9,[r0,#game_cols] 		@r9 = cols count 
	ldr r10,[r0,#game_rows]		@r10 = row count 

	ldr r6,[r0,#game_cols] 
	ldr r7,[r0,#game_rows]

	ldr r0,=space
	bl printf 

header_loop:
	cmp r5,r6
	bgt new_line
	bgt display_game_done

	ldr r0,=std
	mov r1,r5 
	bl printf

	add r5,r5,#1				@increment column counter 
	b header_loop				@loop!

new_line:
	ldr r0,=newLine
	bl printf

grid_loops:
	mov r5,#1					@row counter
	mov r6,#1					@col counter 
print_row:
	cmp r5,r10					@done looping?
	movgt r0,#1					@if yes, then you won!
	bgt display_game_done		@and be done 

	ldr r0,=std 				@load standard message outline 
	mov r1,r5		
	bl printf 					@prints out grid row number on side 

print_col:
	cmp r6,r9					@done looping?
	bgt print_col_done			@get out, to go back to row_loop 

	mov r0,r4 					@param 1 void *game 
	mov r1,r5 					@param 2 row 
	mov r2,r6					@param 3 col 
	bl game_index 				@puts array of cell in r0 

	ldr r1,[r0,#cell_actual]	@load current character 
	
	ldr r0,=item				@standard format 
	bl printf					@prints index 

	add r6,r6,#1				@increment col 
	b print_col 				@keep looping 

print_col_done:
	add r5,r5,#1				@increment row
	mov r6,#1					@set col back to 0 for next time around 

	ldr r0,=newLine  			@print out new line for new row 
	bl printf 

	b print_row					@loop row 

display_game_done:
	pop {r4-r10,lr}
	bx lr

.global set_cell_actual
@
@ int set_cell_actual(void *game, int row, int col, char ch);
@ Returns: 1 if the answer value is correct
@
set_cell_actual:
	push {r4-r8,lr}
	
	mov r4,r3 					@save ch 

	bl game_index				@pointer to index in r0

	str r4,[r0,#cell_actual]	@store user guess
	ldr r1,[r0,#cell_expected]	@load correct answer 

	cmp r1,r4 					@compare ch's
	moveq r0,#1					@if correct, return 1
	movne r0,#0					@if wrong, return 0
	
set_cell_actual_done:
	pop {r4-r8,lr}
	bx lr

.global set_cell_expected
@
@ void set_cell_expected(void *game, int row, int col, char ch);
@
set_cell_expected:
	push {r4-r8,lr}
	
	mov r4,r3          			@ save ch in r4
    bl game_index

    str r4,[r0,#cell_expected]  @ save ch into game
	
	pop {r4-r8,lr}
	bx lr


.global game_win
@
@ int game_win(void *game)
@ Returns true when the game is done/won
@
game_win:
	push {r4-r10,lr}
	
	mov r4,r0 					@save array to game 

	ldr r9,[r0,#game_cols] 		@r9 = cols count 
	ldr r10,[r0,#game_rows]		@r10 = row count 

	mov r5,#1					@row counter
	mov r6,#1					@col counter 
row_loop:
	cmp r5,r10					@done looping?
	movgt r0,#1					@if yes, then you won!
	bgt game_win_done			@and be done 

col_loop:
	cmp r6,r9					@done looping?
	bgt col_loop_done			@get out, to go back to row_loop 

	mov r0,r4 					@param 1 void *game 
	mov r1,r5 					@param 2 row 
	mov r2,r6					@param 3 col 
	bl game_index 				@puts array of cell in r0 

	ldr r1,[r0,#cell_expected]	@load correct answer 
	ldr r2,[r0,#cell_actual]	@load user guess

	cmp r1,r2					@compare correct and inputed 
	movne r0,#0					@not equal, thus not won 
	bne game_win_done 			@done if wrong 

	add r6,r6,#1				@increment col 
	b col_loop 					@keep looping 

col_loop_done:
	add r5,r5,#1				@increment row
	mov r6,#1					@set col back to 0 for next time around 
	b row_loop					@loop row 
	
game_win_done:
	pop {r4-r10,lr}
	bx lr

.global game_index
@
@ int *game_index(void *game, int row, int col)
@ Get the address of a row and column in the cells
@ row and col both start at index 1
@	
game_index:
	push {r4-r8,lr}

	sub r1,r1,#1					@get offset correct
	sub r2,r2,#1					@get offset correct


	ldr r4,[r0,#game_cols]			@find col num 
	ldr r0,[r0,#game_array] 		@pointer to array begining

	mov r5,#cell_size
	mul r4,r4,r1 					@(r*cols)
	add r4,r4,r2					@(r*cols+c)
	mul r4,r4,r5					@(r*cols+c)*cell_size 
	add r0,r0,r4					@array_address + (r*cols+c)*cell_size
	
	pop {r4-r8,lr}
	bx lr
	
	
