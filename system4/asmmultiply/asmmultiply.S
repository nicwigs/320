

.text
.global dumb_multiply
.global multiply
.global signed_multiply


@
@ Multiply two numbers together by brute force
@ r0 - First unsigned value
@ r1 - Second unsigned value
@ Returns r0 * r1
@
dumb_multiply:
	mov r2, #0
while:
	movs r1,r1	@Test if r1==0
	beq done	@exit

	add r2,r2,r0	@add a to sum 
	sub r1,r1,#1	@decrament b
	b while
done:
	mov r0,r2
	bx lr

@
@ Multiply two numbers together efficiently
@ r0 - First unsigned value
@ r1 - Second unsigned value
@ Returns r0 * r1
@
multiply:
  mov r2,#0       @initalize sum
while2:
  movs r0,r0      @test if a is 0
  beq done2        @if a is 0, exit

  ands r3,r0,#1   @a & 1
  addne r2,r2,r1  @sum +=b

  lsr r0,r0,#1    @a>>=1
  lsl r1,r1,#1    @b<<=1
  b while2
done2:
  mov r0,r2
  bx lr

@
@ Multiply two signed numbers together efficiently
@ r0 - First  value
@ r1 - Second value
@ Returns r0 * r1
@
signed_multiply:

  mov r3,#0
  movs r0,r0        @get flags on r0
  bpl negative_r0   @jump down to negative_r0

positive_r0:        @if r0 is positive
  movs r1,r1        @get flags on r1
  bpl multiply      @if r1 is also positive 
  submi r1,r3,r1    @negate r1
  b neg_multiply    @call the multiply that will negate

negative_r0:        @if r0 is negative
  submi r0,r3,r0    @negate r0
  movs r1,r1        @get flags on r1
  bpl multiply      @if r1 is also positive 
  submi r1,r3,r1    @negate r1
  b neg_multiply    @call the multiply that will negate

neg_multiply:
  mov r2,#0       @initalize sum
neg_while:
  movs r0,r0      @test if a is 0
  beq neg_done        @if a is 0, exit

  ands r3,r0,#1   @a & 1
  addne r2,r2,r1  @sum +=b

  lsr r0,r0,#1    @a>>=1
  lsl r1,r1,#1    @b<<=1
  b neg_while
neg_done:
  mov r0,r2
  mov r3,#0
  sub r0,r3,r0    @make result negative 
  bx lr          @return negative of multiply


