@ Benny Stellhorn
@ bas0042@uah.edu
@ CS413- 01- Fall 2021

.equ READERROR, 0 @Used to check for scanf read error.

.global main
main:


prompt:		@ prompt user for an input
	ldr r0, =welcome
	bl printf

get_input:
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intSelect        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR       @ Check for a read error.
	beq readerror            @ If there was a read error go handle it. 
	ldr r1, =intSelect        @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 


	cmp r1, #1	@1 input
	beq oneIn
	cmp r1, #2
	beq twoIn	@2 inputs
	cmp r1, #3
	beq twoIn	@2 inputs
	cmp r1, #4
	beq threeIn	@3 inputs
	cmp r1, #5
	beq myexit	@ quit

	b prompt

areas:

	ldr r1, =intSelect
	ldr r1, [r1]
	cmp r1, #1	@1 input
	bleq square
	cmp r1, #2
	bleq rectangle	@2 inputs
	cmp r1, #3
	bleq triangle 	@2 inputs
	cmp r1, #4
	bleq trapezoid	@3 inputs


	b print
	b myexit


@***************************	
oneIn:
@***************************
	ldr r0, =oneInStr
	bl printf
	
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intHeight        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR       @ Check for a read error.
	beq readerror            @ If there was a read error go handle it. 
	ldr r1, =intHeight        @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 


	@check if input is positive
	cmp r1, #0
	bmi oneIn

	push {r1}

	
	b areas


@***************************
twoIn:
@***************************	
	ldr r0, =twoInStr
	bl printf


@base
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intBase        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR       @ Check for a read error.
	beq readerror            @ If there was a read error go handle it. 
	ldr r1, =intBase       @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 


	@check if input is positive
	cmp r1, #0
	bmi twoIn

	push {r1}
	
@height
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intHeight        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR       @ Check for a read error.
	beq readerror            @ If there was a read error go handle it. 
	ldr r1, =intHeight        @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 


	@check if input is positive
	cmp r1, #0
	bmi twoIn
	mov r2, r1
	push {r2}
	b areas


@***************************
threeIn:
@***************************	
	ldr r0, =threeInStr
	bl printf

@base 1
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intBase        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR       @ Check for a read error.
	beq readerror            @ If there was a read error go handle it. 
	ldr r1, =intBase       @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 


	@check if input is positive
	cmp r1, #0
	bmi threeIn

	push {r1}

	
@base 2
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intBase        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR       @ Check for a read error.
	beq readerror            @ If there was a read error go handle it. 
	ldr r1, =intBase       @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 


	@check if input is positive
	cmp r1, #0
	bmi threeIn

	push {r1}

@height
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intHeight        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR       @ Check for a read error.
	beq readerror            @ If there was a read error go handle it. 
	ldr r1, =intHeight        @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 


	@check if input is positive
	cmp r1, #0
	bmi threeIn

	push {r1}
	
	b areas
	

	



myexit:	
	mov r7, #0x01
	svc 0

print:
	ldr r0, =prints
	bl printf
	pop {r7}
	mov r1, r7
	ldr r0, =numOutputPattern
	bl printf
	b prompt

rectangle:
	pop {r3}
	pop {r4}

	umull r5, r6, r3, r4
	cmp r6, #0
	bne overflowerror

	push {r5}
	bx lr



triangle:
	pop {r3}
	pop {r4}

	umull r5, r6, r3, r4
	cmp r6, #0
	bne overflowerror
	lsr r7, r5, #1
	push {r7}
	bx lr
	

trapezoid:
	pop {r3}
	pop {r4}
	pop {r5}

	add r6, r4, r5
	lsr r7, r6, #1
	umull r8, r6, r3, r7
	cmp r6, #0
	bne overflowerror

	push {r8}
	bx lr


square:
	pop {r3}
	mov r4, r3

	umull r5, r6, r3, r4
	cmp r6, #0
	bne overflowerror

	push {r5}
	bx lr


@***********
overflowerror:
@***********

@print overflow error
ldr r0, =overflowstr
bl printf
b prompt


@***********
readerror:
@***********
@ Got a read error from the scanf routine. Clear out the input buffer then
@ branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.

   b prompt

	
.data 
.balign 4
welcome: .asciz "\nChoose a shape to calculate an area\nSquare: 1\nRectangle: 2\nTriangle: 3\nTrapezoid:4\nQuit: 5\n"

.balign 4
oneInStr: .asciz "Please enter one positve number\n"

.balign 4
twoInStr: .asciz "Please enter two positve numbers\n"

.balign 4
threeInStr: .asciz "Please enter three positve numbers\n"

.balign 4 
prints: .asciz "area: "

.balign 4
overflowstr: .asciz "overflow error\n"

.balign 4
numInputPattern: .asciz "%d"

.balign 4
numOutputPattern: .asciz "%d"

.balign 4
intSelect: .word 0   @ Location used to store the user selection. 

.balign 4
intBase: .word 0   @ Location used to store the user base. 

.balign 4
intHeight: .word 0   @ Location used to store the user height. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 


.global printf
.global scanf

