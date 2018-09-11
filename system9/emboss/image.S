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

zero:	.double 0

d:
	.asciz "%f \n"
i:
	.asciz "%d \n"
.text
 
.global create_image
@
@ void *create_image(int wid, int hit)
@ Create an image ADT and return it.
@
create_image:
	push {r4-r8, lr}

	mov r4,r0							@store r4 = width 
	mov r5,r1 							@store r5 = height 

	mov r0,#1							@num 
	mov r1,#image_size					@size 
	bl calloc 							@ void* calloc (size_t num, size_t size);

	str r4,[r0,#image_cols]				@image->cols = width 
	str r5,[r0,#image_rows]				@image->rows = height  

	mov r6,r0							@save image pointer

	mul r0,r4,r5						@num = width * height
	mov r1,#pixel_size					@size = 8 for double 
	bl calloc 							@void* calloc (size_t num, size_t size);

	str r0,[r6,#image_array]			@store array in image 

	mov r0,r6							@move image pointer back 

create_image_done:
	pop {r4-r8, lr}
	bx lr

.global destroy_image	
@
@ void destroy_image(void *image)
@ Destroy image, freeing memory
@
destroy_image:
	push {r4, lr}

	mov r4,r0							@save image pointer

	ldr r0,[r0,#image_array]			@Load image array
	bl free 							@free array

	mov r0,r4 							@get image pointer
	bl free 							@free image 

	pop {r4, lr}
	bx lr

.global get_width
@
@ int get_width(void *image)
@ Get the width of the image
@
get_width:
	ldr r0,[r0,#image_cols]
	bx lr
	
.global get_height
@
@ int get_height(void *height)
@ Get the height of the image
@
get_height:
	ldr r0,[r0,#image_rows]
	bx lr
	
.global set_pixel
@
@ void set_pixel(void *image, int row, int col, double value)
@ row and col are 0 based 
@
set_pixel:
	push {r4-r8,lr}

	ldr r3,[r0,#image_cols] 			@store col num in r3
	ldr r4,[r0,#image_array]			@pointer to first val in array (0,0)

	mov r5,#pixel_size					@size of each pixel double val in array 

	mul r3,r3,r1 						@(r*cols)
	add r3,r3,r2						@(r*cols+c)
	mul r3,r3,r5						@(r*cols+c)*size 
	add r6,r4,r3						@array_address + (r*cols+c)*size

	vstr d0,[r6]						@store double at address array + offset 

	@ldr r0,=i
	@mov r1,r6
	@bl printf

	pop {r4-r8,lr}
	bx lr

.global get_pixel
@
@ double get_pixel(void *image, int row, int col)
@
get_pixel:
	push {r4-r8,lr}

	ldr r3,[r0,#image_cols] 			@store col num in r3
	ldr r4,[r0,#image_array]			@pointer to first val in array (0,0)

	cmp r2,#0							@compare col num and 0
	blt out_of_range

	cmp r2,r3							@compare col num and max col number 
	bge out_of_range

	mov r5,#pixel_size					@size of each pixel double val in array 
	mul r3,r3,r1 						@(r*cols)
	add r3,r3,r2						@(r*cols+c)
	mul r3,r3,r5						@(r*cols+c)*cell_size 
	add r6,r4,r3						@array_address + (r*cols+c)*size

	vldr d0,[r6]						@load double at address array + offset 
	b done

out_of_range:
	ldr r8,=zero 						
	vldr d1,[r8] 						@d1 = 0
	vmov d0,d1 						    @set val to black (0)

done: 

	pop {r4-r8,lr}
	bx lr

