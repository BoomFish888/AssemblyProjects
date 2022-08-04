@ Filename: Stellhorn.s
@ Author:   Benny Stellhorn
@ Purpose:  Print the factorials of all integers up to a given input between 1-12
@ Class:    309-02
@ Date:	    4/3/21

@ NOTE: This code was adapted from student_inputC.s.
@ As a result, some comments were left over from the original author.
@ unchanged code has comments left by the original author
@ However, everything else is my original work 

.equ READERROR, 0 @Used to check for scanf read error. 
.equ MAXVAL, 12 @used to check if the user inputed a number larger than 12
.equ MINVAL, 1 @ used to check if the user inputed a number smaller than 1

.global main @ Have to use main because of C library uses. 

main:


@*******************
prompt:
@*******************

@ Ask the user to enter a number.
 
   ldr r0, =strInputPrompt @ Put the address of my string into the first parameter

startingAddressBreakpoint:	@This is to provide a breakpoint for the debugger portion of 
				@ the assignment
   bl  printf              @ Call the C printf to display input prompt. 

@*******************
get_input:
@*******************

@ Set up r0 with the address of input pattern.
@ scanf puts the input value at the address stored in r1. We are going
@ to use the address for our declared variable in the data section - intInput. 
@ After the call to scanf the input is at the address pointed to by r1 which 
@ in this case will be intInput. This aslo checks if the input is between 1 and 12

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of the user input number
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerror            @ If there was a read error go handle it. 
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out.
   ldr r4, [r1]		    @ copy r1 into r4 to do comparisons
   cmp r4, #MINVAL	    @ Compare input to Min value
   blt readerror	    @ If lower, ask for a new input
   cmp r4, #MAXVAL	    @ Compare input to Max value
   bgt readerror	    @ If lower, ask for a new input   


   @value should now be usable   

   ldr r1, =intInput		@make sure the register is set to the input
   ldr r1, [r1] 		@set to the literal value for printing
   ldr r0, =strUserOutput	@set r0 to the correct string format
   bl  printf			@insert input and print 
   ldr r1, =intInput		@reset r1 to equal the input address
   ldr r1, [r1]			@reset r1 ro the literal value of the input
   
   mov r7, #1  			@set r7 to 1. This will be our product register
   mov r5, r1			@set r5 to r1 to hold the input in a non-changing register
   ldr r0, =strPrep		@set r0 to the correct string to show the decription and table
   bl printf			@print description and table
   mov r4, #1			@set r4 to 1. This will be our counter register
   mov r1, r4			@set r1 to r4 so it can be printed
   ldr r0, =strCounterNum	@set r0 to the correct string to format the counter to fit in the table
   bl printf			@print counter register in table
   bl  loop 			@begin the loop that will give the factorials
   
@*****************
loop:
@*****************

@ Starts by multiplying the counter and the product registers
@ Updates the product register and prints it
@ increments the counter register and prints it
@ loops until the counter has exceeded the input 



loopStartBreakpoint:		@This is to provide a breakpoint for the debugger portion of 
				@ the assignment
	
   muls r6, r7, r4		@multiply input val with previous val and save in r6
   mov r7, r6 			@stores the product of the multiplication into the product register
   mov r1, r7			@copy the contents of r7 into r1 so it can be printed
   ldr r0, =strOutputNum	@set r0 to the correct string to format the counter to fit in the table
   bl  printf			@print the product register
   
   
   adds r4, r4, #1		@increment counter register
   mov r1, r4			@copy the contents of r4 into r1 so it can be printed
   cmp r4, r5			@check if the counter register has exceeded the input number	
   bgt endLoopBreakpoint	@if greater than, exit the loop before printing
   ldr r0, =strCounterNum	@set r0 to the correct format to print in the table
   bl printf			@print the counter register

loopStepBreakpoint:		@This is to provide a breakpoint for the debugger portion of 
				@ the assignment

   ble loop			@if not, continue looping 


endLoopBreakpoint:		@This is to provide a breakpoint for the debugger portion of 
				@ the assignment

   ldr r0, =strEnd		@set r0 to the correct string to print the end of the program

lastPrintBreakpoint:		@This is to provide a breakpoint for the debugger portion of 
				@ the assignment
   bl printf			@print the end

endBreakpoint:			@This is to provide a breakpoint for the debugger portion of 
				@ the assignment

   b myexit			@terminate program before it tries to run other methods
   
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

@*******************
myexit:
@*******************
@ End of my code. Force the exit and return control to OS

   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call. 

.data

@ Declare the strings and data needed

.balign 16
strInputPrompt: .asciz "This program will print the factorial of the integers from 1 to a number you enter.\nInput a number between 1-12: \n"
	@used to prompt the user for an input and describes the program
.balign 4
strOutputNum: .asciz "    %d   \n"
	@used to format the product register. has \n to create the table

.balign 4
strEnd: .asciz "\nEnd of program \n"
	@used to be the last thing printed for the debugging portion of the assignmnet 


.balign 4
strUserOutput: .asciz "You entered %d.   \n"
	@ Format pattern for scanf call.

.balign 4
strCounterNum: .asciz "   %d   "
	@used to format the counter register. does not have \n to create the table

.balign 16
strPrep: .asciz "Following is the number and the product of the integers from 1 to n. \n \nNumber     n!\n\n"
	@used to describe and begin the table of values containing the counter and the factorials
.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 

.balign 4
intInput: .word 0   @ Location used to store the user input. 


@ Let the assembler know these are the C library functions. 

.global printf
@  To use printf:
@     r0 - Contains the starting address of the string to be printed. The string
@          must conform to the C coding standards.
@     r1 - If the string contains an output parameter i.e., %d, %c, etc. register
@          r1 must contain the value to be printed. 
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed. 

.global scanf
@  To use scanf:
@      r0 - Contains the address of the input format string used to read the user
@           input value. In this example it is numInputPattern.  
@      r1 - Must contain the address where the input value is going to be stored.
@           In this example memory location intInput declared in the .data section
@           is being used.  
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed.
@ Important Notes about scanf:
@   If the user entered an input that does NOT conform to the input pattern, 
@   then register r0 will contain a 0. If it is a valid format
@   then r0 will contain a 1. The input buffer will NOT be cleared of the invalid
@   input so that needs to be cleared out before attempting anything else.
@
@ Additional notes about scanf and the input patterns:
@    1. If the pattern is %s or %c it is not possible for the user input to generate
@       and error code. Anything that can be typed by the user on the keyboard
@       will be accepted by these two input patterns. 
@    2. If the pattern is %d and the user input 12.123 scanf will accept the 12 as
@       valid input and leave the .123 in the input buffer. 
@    3. If the pattern is "%c" any white space characters are left in the input
@       buffer. In most cases user entered carrage return remains in the input buffer
@       and if you do another scanf with "%c" the carrage return will be returned. 
@       To ignore these "white" characters use " $c" as the input pattern. This will
@       ignore any of these non-printing characters the user may have entered.
@

@ End of code and end of file. Leave a blank line after this.
