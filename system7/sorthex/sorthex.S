.data

msg: .asciz "%d %d\n"

.text

.global sorthex

@
@ void sorthex(data, size)
@ Sort data into hexadecimal order by 
@ half-bytes.
@
sorthex:
	stmfd sp!,{r4-r10,lr}

	@
	@ Save off parameters into safe registers
	@
	data .req r4
	mov data, r0
	size .req r5
	mov size, r1
	
	@ Number of hex values
	size2 .req r6
	lsl size2, size, #1
	
	i .req r7	@ outer loop counter
	mov i,#0
	
outer_loop:
	cmp i,size2
	bge sorthex_done @changed from bgt
	
	j .req r8	@ inner loop counter
	add j,i,#1
inner_loop:
	cmp j,size2
	bge outer_loop_end @changed from bgt
	
	mov r0,data
	mov r1,size
	mov r2,i
	bl gethex
	
	aa .req r9
	mov aa,r0
	
	mov r0,data
	mov r1,size
	mov r2,j
	bl gethex
	
	bb .req r10
	mov bb,r0
	
	@
	@ Do we need to swap
	@
	cmp aa, bb
	ble after_swap

	mov r0,data
	mov r1,size
	mov r2,j
	mov r3,aa @changed from bb
	bl sethex
	
	
	mov r0,data
	mov r1,size
	mov r2,i
	mov r3,bb @changed from aa 
	bl sethex
	
after_swap:
	add j,j,#1
	b inner_loop
	
outer_loop_end:	
	add i,i,#1
	b outer_loop

sorthex_done:
	ldmfd sp!,{r4-r10,lr}
	bx lr
	
