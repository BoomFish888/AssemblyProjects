@ Filename: user_inputA.s
@ Author: Kevin Preston
@ Purpose: Show CS309 students how to read user inputs from KB. 
@    Date         Rev    comments
@     2018         -     Initial version on how to read the user input from Keyboard,
@    25-Sep-2019   A     Added code and loops to handle invalid user inputs.
@
@ To stop running this code use ctrl-c.
@ Looks like some strange things will happen if the invalid input contains spaces. 
@   ----- Solve this on another day. ----
@
@ Use these command to assemble, link and run this program
@    as -o user_inputA.o user_inputA.s
@    gcc -o user_inputA user_inputA.o
@    ./user_inputA ;echo $?
@    gdb --args ./user_inputA

.global main @ Have to use main because of C library uses. 
main:

prompt:
@ Ask the user to enter a number. 
   ldr r0, =strInputPrompt @ Put the address of my string into the first parameter 
   bl printf               @ Call the C print to display input prompt. 

get_input:
@ Set up r0 with the address of input pattern 

   ldr r0, =numInputPattern @ Setup to read in one number.

@ scanf puts the input value at the address stored in r1. We are going
@ to use the stack (sp) for that address. But first we have to subtract from the
@ stack to get a new pointer to an unused location. After that call scanf.
@ The value read from the input is stored at the address pointed to by 
@ sp. Load the value into r1 and add to the stack to what is was before. 

   sub sp, sp, #4           @ Update stack pointer to new loc.
   mov r1, sp               @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
   ldr r1, [sp, #0]         @ The character is on the stack. 
   add sp, sp, #4           @ Reset the stack. 

@
@ If the user entered an input that does NOT conform to the input pattern, 
@ (in this case %d) then register r0 will contain a 0. If it is a valid format
@ then r0 will contain a 1. The input buffer will NOT be cleared of the invalid
@ input so that needs to be cleared out before attempting anything else. 
@
@ Check for invalid input r0 =0 
   cmp r0, #0
   bne printinputasNum     @the input is valid print it

@ An invalid entry was made we not have to clear out the input buffer by
@ reading in a string (%s). 

   ldr r0,=stringInputPattern
   sub sp, sp, #4           @ Update stack pointer to new loc.
   mov r1, sp               @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
   ldr r1, [sp, #0]         @ The character is on the stack. 
   add sp, sp, #4           @ Reset the stack. 

@ The input buffer should now be clear so get another input.
   b prompt

@ Print the input out as a number. 

printinputasNum:
   ldr r0, =strOutputNum
   bl printf

   b prompt @keep getting inputs.

@End of my code. Force the exit and return control to OS

myexit:
   mov r7, #0x01 @SVC call to exit
   svc 0         @Make the system call. 

.data
@ Declare the strings and data needed
.balign 4
strInputPrompt: .asciz "Input the number: "

.balign 4
stringInputPattern: .asciz "%s" @ Used to clear the input buffer for invalid input. 

.balign 4
strOutputNum: .asciz "The number value is: %d \n"

@ Format pattern for scanf call. 
.balign 4
numInputPattern: .asciz "%d"

@ Let the assembler know these are the C library functions. 
.global printf
.global scanf

@end of code. 
