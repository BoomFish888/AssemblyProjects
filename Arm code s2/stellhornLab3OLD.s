@ Benny Stellhorn
@ bas0042@uah.edu
@ CS413- 01- Fall 2021


.equ READERROR, 0 		@Used to check for scanf read error. 
.equ STARTVAL, 2

.global main
main:

@note to self: used registers
@ r2 = cost
@ r3 = user total
@ r7 = user selection


prompt:		@ prompt user for an input
	ldr r0, =welcome
	bl printf

	ldr r0, =charInputPattern @ Setup to read in one number.
	ldr r1, =charInput        @ load r1 with the address of the user input number
	bl  scanf                @ scan the keyboard.
	ldr r1, =charInput
	ldr r1, [r1]		@move into r7 to make sure it's not cleared
		

	cmp r1, #'g'
	beq gum
	@cmp r1, #'P'
	@cmp r1, #'C'
	@cmp r1, #'M'
	
	
   

b readerror


gum:
	ldr r0, =gumstr
	bl printf
	mov r4, #50 	@r2 will be the cost of the item
	mov r3, #0	@r3 will be the user's total
	
	
	ldr r0, =charInputPattern @ Setup to read in one number.
	ldr r1, =charInput1        @ load r1 with the address of the user input number
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR
	@beq readerror            @ If there was a read error go handle it. 
	ldr r1, =charInput1
	ldr r1, [r1]

			
	cmp r1, #'d'
	str r3, [r1]
	beq gumDime
	


gumDime:
	ldr r0, =dimestr
	bl printf
	
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR       @ Check for a read error.
	beq readerror            @ If there was a read error go handle it. 
	ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 
	mov r5, #10
	mov r1, r6
	mul r8, r6, r5
	add r3, r8
	cmp r4, r3
	blt gum
	b change
	
change:


myexit:	
	mov r7, #0x01
	svc 0




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

@Declare strings and integers

.balign 4
welcome: .asciz "Welcome to vending machine. \n"	
	@used to welcome the user 

.balign 4 
gumstr: .asciz "Enter $0.50.\nD - Dimes\nQ - Quarters\nB - Bills\n"

.balign 4 
dimestr: .asciz "Enter the number of dimes\n"

.balign 4
numInputPattern: .asciz "%d"  
	@ integer format for read.
.balign 4
charInputPattern: .asciz "%c"
 	@char format
.balign 4
strInputPattern: .asciz "%[^\n]" 
	@ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  
	@ User to clear the input buffer for invalid input.

.balign 4
intInput: .word 0 

.balign 4
cost: .word 0   
	@ Location used to store the user input. 
.balign 4
charInput: .word '0'

.balign 4
charInput1: .word '0'


.global printf
	@used to print  
.global scanf 
	@used to get user input
