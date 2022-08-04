@ Benny Stellhorn
@ bas0042@uah.edu
@ CS413- 01- Fall 2021

.equ READERROR, 0 @Used to check for scanf read error.

.global main
main:


prompt:		@ prompt user for a positive input
	ldr r0, =welcome
	bl printf

get_input:
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intBase        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR       @ Check for a read error.
	beq readerror            @ If there was a read error go handle it. 
	ldr r1, =intBase        @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 


	@check if input is positive
	cmp r1, #0
	bmi prompt
	
	push {r1}

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
	bmi prompt

	push {r1}
	bl rectangle

	pop {r1}
	ldr r0, =numOutputPattern	@set r0 to the correct string format
	
	
	bl  printf			@insert input and print 

	
@give the user an option to choose an area type


myexit:	
	mov r7, #0x01
	svc 0



rectangle:
	pop {r3}
	pop {r4}

	mul r5, r3, r4
	cmp r5, #0
	bvs overflowerror

	push {r5}
	bx lr



triangle:

trapezoid:

square:



@***********
overflowerror:
@***********

@print some stuff about overflow
b myexit

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
welcome: .asciz "Welcome to lab 2. Enter a positive base integer and positive height integer\n"

.balign 4
numInputPattern: .asciz "%d"

.balign 4
numOutputPattern: .asciz "%d"

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

