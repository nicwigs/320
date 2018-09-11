@
@ My first assembly language program
@Name: Nic Wiggins
@

.text
.global first
.global second

first:
@  mov r1,r0
@  add r0,r0,r1
@  add r0,r0,r1

  mov r1, #0 @0 cnt
  mov r2,#0 @i
forloop:
  subs r3,r2,#32
  beq loopend
  
  ands r3,r0,#1  @r0 & 1
  addne r1,r1,#1 @cnt++
  lsr r0,r0,#1  @value >>=1



  add r2,r2,#1    @i++
  b forloop

  bx lr
loopend:
  mov r0,r1
  bx lr

second:
  add r0,r0,r1
  bx lr
