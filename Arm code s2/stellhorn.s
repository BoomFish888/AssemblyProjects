@ Benny Stellhorn
@ bas0042@uah.edu
@ CS413- 01- Fall 2021

.equ READERROR, 0 @Used to check for scanf read error. 

.global main
main:


prompt:		@ prompt user for an input 1-10
	ldr r0, =welcomeString
	bl printf
	
get_input:
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	cmp r0, #READERROR       @ Check for a read error.
	beq readerror            @ If there was a read error go handle it. 
	ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 


	@check if input is between 1-10
	cmp r1, #0
	@if less than equal to 0, prompt again
	ble prompt
	cmp r1, #10
	@if greater than 10, prompt again
	bgt prompt
	mov r4, r1 @move the counter into an unchanging register
	@start print loop
helloloop:	
	@ print hello world
	LDR  r0, =string1 @ Put address of string in r0
    	BL   printf       @ Make the call to printf
	
	mov r5, #1
	@subtract 1 from counter
	subs r4, r4, r5
	@if r4-1 ==0 exit
	beq myexit	

	@ else branch to beginning of loop 
	b helloloop


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

myexit:
    MOV  r7, #0X01
    SVC  0

.data       @ Lets the OS know it is OK to write to this area of memory. 
.balign 4   @ Force a word boundry.
string1: .asciz "Hello World.\n"  @Length 0x0E

.balign 4 
welcomeString: .asciz "Welcome! Please enter a number between 1-10\n"

.balign 4
numInputPattern: .asciz "%d"

.balign 4
intInput: .word 0   @ Location used to store the user input. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 


.global printf
.global scanf
