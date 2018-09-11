@Creates a tricorn image
.data
    .balign 8
	x:		.double 0   
	y:		.double 0	
	four:	.double 4
	two:	.double 2
.text

.global tricorn
@int tricorn(double x0, double y0)
@d0 = x0
@d1 = y0
@r0 = iteration

tricorn:
	stmfd sp!,{r4-r8,lr}

	mov r0,#0				@iteration = 0

	ldr r1,=x
    vldr d2,[r1]   			@d2 = x

    ldr r2,=x
    vldr d3,[r2]    		@d3 = y

loop:

condition_1:
	vmul.f64 d4,d2,d2		@d4 = x^2
	vmul.f64 d5,d3,d3		@d5 = y^2
	vadd.f64 d6,d4,d5		@d6 = x^2+y^2

	ldr r1,=four
	vldr d7,[r1]			@d7 = 4   
	vcmp.f64 d6,d7      	@compare x^2+y^2 < 4?
    vmrs APSR_nzcv, fpscr   @ move to CPSR
    bge done

condition_2:
    cmp r0,#255				@iteration < 255
    bge done

loop_body:
	vsub.f64 d6,d4,d5		@d6 = x1 = x^2-y^2
	vadd.f64 d6,d6,d0		@d6 = x1 = x^2-y^2+x0
	
	ldr r1,=two
	vldr d4,[r1]			@d4 = 2  
	vmul.f64 d5,d2,d3		@d5 = y1 = xy
	vmul.f64 d5,d4,d5		@d5 = y1 = 2xy
	vsub.f64 d5,d1,d5		@d5 = y1 = y0 - 2xy

	vmov d2,d6				@x =x1
	vmov d3,d5				@y = y1

loop_end:
	add r0,r0,#1			@iteration++
	b loop 					@loop
done:	
	ldmfd sp!,{r4-r8,lr}
    bx lr
