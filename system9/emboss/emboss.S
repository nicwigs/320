.data

@
@ Image description data structure
@
.equ    image_rows, 0
.equ    image_cols, 4			
.equ    image_array,8
.equ    image_size, 12			

@
@ The pixel data structure
@ This is the contents of a location in the array
@
.equ    pixel, 0
.equ 	pixel_size,8

.balign 8

	half:	.double 0.5

.text

.global emboss
@
@ void *emboss(void *src)
@
emboss:
	push {r4-r10, lr}

	mov r10,r0 							@r10 = old image  

	ldr r4,[r0,#image_rows]				@r4 = rows 
	ldr r5,[r0,#image_cols]				@r5 = cols 

	mov r0,r5							@width = cols
	mov r1,r4 							@height = rows
	bl create_image						@void *create_image(int wid, int hit)

	mov r6,r0 							@store new image pointer to r6

loop_init:
	mov r7,#0							@row counter
	mov r8,#0							@col counter 

emboss_row_loop:
	cmp r7,r4 							@done looping?
	bge emboss_loop_done				

emboss_col_loop:
	cmp r8,r5							@done looping?
	bge emboss_col_loop_done

	mov r0,r10 							@old image 
	mov r1,r7							@row
	mov r2,r8 							@col 
	add r2,r2,#1						@col + 1 ir,c+1 
	bl get_pixel						@double get_pixel(void *image, int row, int col)

	vmov d1,d0 							@copy pixel c+1 since new call will destroy d0

	mov r0,r10 							@old image 
	mov r1,r7							@row
	mov r2,r8 							@col 
	sub r2,r2,#1						@col + 1 ir,c-1 
	bl get_pixel						@double get_pixel(void *image, int row, int col)

	ldr r1,=half 						
	vldr d2,[r1] 						@d2 = 0.5 
	vsub.f64 d0,d1,d0 					@O = i(c+1) - i(c-1)
	vadd.f64 d0,d0,d2 					@O = i(c+1) - i(c-1) + 0.5

	mov r0,r6 							@new image pointer
	mov r1,r7							@row
	mov r2,r8 							@col
	@vmov d0,d0 						@value
	bl set_pixel 						@void set_pixel(void *image, int row, int col, double value)

	add r8,r8,#1 						@increment col
	b emboss_col_loop 					@loop!

emboss_col_loop_done:
	add r7,r7,#1 						@increment row
	mov r8,#0 							@set col back to 0 for next time around
	b emboss_row_loop 					@loop row

	mov r0,r6 							@move new image pointer 

emboss_loop_done:
	
	pop {r4-r10, lr}
	bx lr
