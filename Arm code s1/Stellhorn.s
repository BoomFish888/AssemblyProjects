@ Filename: Stellhorn.s
@ Author:   Benny Stellhorn
@ Purpose:  Simulate the use of a gas pump 
@ Class:    309-02
@ Date:	    4/11/21


.equ READERROR, 0 		@Used to check for scanf read error. 
.equ MAXVAL, 50 		@used to check if the user inputed a number larger than 50
.equ MINVAL, 1 			@used to check if the user inputed a number smaller than 1
.equ GASSTARTVAL, 500 		@used to initialize the starting values of all the pumps
.equ CHARREGULAR, 'R'		@used to check for correct gas input
.equ CHARMID, 'M'		@used to check for correct gas input
.equ CHARPREMIUM, 'P'		@used to check for correct gas input
.equ CHARSECRET, 'Z'		@used to check for the getInventory secret
.equ REGDOLLAR, 4		@amount of regular gas per dollar
.equ MIDDOLLAR, 3		@amount of mid grade gas per dollar
.equ PREMIUMDOLLAR, 2		@amount of premium gas per dollar 


.global main @ Have to use main because of C library uses. 

main:

ldr r0, =strWelcome	@Put the address of the welcome string into the first parameter
bl printf 		@call printf to display

mov r4, #GASSTARTVAL	@assign starting gas value to r4 to be printed for regular
mov r5, #GASSTARTVAL	@assign starting gas value to r5 to be printed for mid grade
mov r6, #GASSTARTVAL	@assign starting gas value to r6 to be printed for premium

mov r7, #0		@assign zero to the regular gas cash register
mov r8, #0		@assign zero to the mid grade gas cash register
mov r9, #0		@assign zero to the premium gas cash register

bl getInventory

bl get_input
breakpointZ:
b myexit


@****************
getInventory:
@****************

stmfd sp!,{lr}

ldr r0, =strGasInventory	@assign address to the inventory start string
bl printf			@call printf to display

ldr r0, =intRegular		@assign address to regular gas string
mov r1, r4			@set r1 to the regular register to print
bl printf			@call printf to display

ldr r0, =intMid			@assign address to mid grade string
mov r1, r5			@set r1 to the mid grade register to print
bl printf			@call printf to display

ldr r0, =intPremium		@assign address 
mov r1, r6			@set r1 to the premium register to print
bl printf			@call printf to display

ldr r0, =strCashInventory	@assign address to the cash inventory start string
bl printf			@call printf to display

ldr r0, =intRegular		@assign address to regular gas string
mov r1, r7			@set r1 to the regular cash register to print
bl printf			@call printf to display

ldr r0, =intMid			@assign address to mid grade string
mov r1, r8			@set r1 to the mid grade cash register to print
bl printf			@call printf to display

ldr r0, =intPremium		@assign address 
mov r1, r9			@set r1 to the premium cash register to print
bl printf			@call printf to display

ldmfd sp!,{pc}			@return to main
 


breakpointbad:

@*******************
get_input:
@*******************

stmfd sp!,{lr}

bl get_inputGas
bl get_inputCash


cmp r4, #1
cmplt r5, #1
cmplt r6,#1
  blt loadBreakpointBeta 
  blge get_input

loadBreakpointBeta: 
  ldmfd sp!,{r4-r11, pc}
 
@*******************
get_inputGas:
@*******************
@ Ask the user to enter a number.
@ uses r1 to compare to with acceptable chars

mov r10, #0

stmfd sp!,{lr}	 @saves the character and the link register in the stack


breakpt:

@stmfd sp!,{r10}		@saves the character and the link register in the stack

mov r3, #CHARSECRET	@store 'Z' in r3 to compare with input
cmp r10, r3		@compare input to z
beq getInventory	@do secret action of get inventory
beq get_inputGas	@loop back to the start of the method to get a new input

breakpointX:

mov r3, #CHARREGULAR	@store 'R' into r3 to compare with input
cmp r10, r3		@compare user char with 'R'
beq loadBreakpoint	@if true, break to get_input

mov r3, #CHARMID 	@store 'M' into r3 to compare with input
cmp r10, r3		@compare user char with 'M'
beq loadBreakpoint	@if true, break to get_input

mov r3, #CHARPREMIUM	@store 'P' into r3 to compare with input
cmp r10, r3		@compare user char with 'P'
beq loadBreakpoint	@if true, break to get_input

bl readerrorCash

@stmfd sp!,{lr}

b get_inputGas		@none were true ask again 

loadBreakpoint:
ldmfd sp!,{pc}


@*******************
get_inputCash:
@*******************

@ Set up r0 with the address of input pattern.
@ scanf puts the input value at the address stored in r1. We are going
@ to use the address for our declared variable in the data section - intInput. 
@ After the call to scanf the input is at the address pointed to by r1 which 
@ in this case will be intInput. This aslo checks if the input is between 1 and 12
   
   stmfd sp!,{lr}
   
   ldr r0, =strCashPrompt
   bl printf


   ldr r0, = numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of the user input number
   bl  scanf                @ scan the keyboard.
   cmp r0, #READERROR       @ Check for a read error.
   beq readerrorCash        @ If there was a read error go handle it. 
   beq get_inputCash
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out.
   mov r11, r1		    @ copy r1 into r4 to do comparisons
   
   @stmfd sp!,{r11}
   cmp r11, #MINVAL	    @ Compare input to Min value
   blt readerrorCash	    @ If lower, ask for a new input
   blt get_inputCash
   cmp r11, #MAXVAL	    @ Compare input to Max value
   bgt readerrorCash	    @ If lower, ask for a new input   
   bgt get_inputCash   

cmp r10, #CHARREGULAR
  blt safetyBreakpoint1
  mov r0, #REGDOLLAR
  muleq r10, r11, r0
  cmpeq r10, r4
     addle r7, r11, r7
     suble r4, r4, r10
     blgt readerrorCash
     bgt get_inputCash
safetyBreakpoint1:

cmp r10, #CHARMID
   blt safetyBreakpoint2
   mov r0, #MIDDOLLAR
   muleq r10, r11, r0
   cmpeq r10, r5
      addle r8, r11, r8 
      suble r5, r5, r10
      blgt readerrorCash
      bgt get_inputCash
safetyBreakpoint2:

cmp r10, #CHARPREMIUM
   blt safetyBreakpoint3
   mov r0, #PREMIUMDOLLAR
   muleq r10, r11, r0
   cmpeq r10, r6
      addle r8, r11, r8 
      suble r5, r5, r10
      blgt readerrorCash
      bgt get_inputCash
safetyBreakpoint3:


   ldmfd sp!,{pc}			@return up the stack
 
@***********
readerrorCash:
@***********
@ Got a read error from the scanf routine while asking for cash. 
@ Clear out the input buffer then branch back for the user to enter a value. 
@ Since an invalid entry was made we now have to clear out the input buffer by
@ reading with this format %[^\n] which will read the buffer until the user 
@ presses the CR. 

   stmfd sp!,{lr}

   ldr r0, =strInputPattern
   ldr r1, =strInputError   @ Put address into r1 for read.
   bl scanf                 @ scan the keyboard.
@  Not going to do anything with the input. This just cleans up the input buffer.  
@  The input buffer should now be clear so get another input.

   ldmfd sp!,{pc}
 
breakpointY:

@*******************
myexit:
@*******************
@ End of my code. Force the exit and return control to OS

   mov r7, #0x01 @ SVC call to exit
   svc 0         @ Make the system call. 

.data 

@Declare strings and integers

.balign 4
strWelcome: .asciz "Welcome to gasoline pump. \n"	
	@used to welcome the user 

.balign 4
strGasInventory: .asciz "Current inventory of gasoline (in tenths of a gallon): \n\n"
	@used to preface the inventory of gas 

.balign 4
strCashInventory: .asciz "Dollar amount dispensed by grade: \n\n"
	@used to preface inventory of cash

.balign 16
strGasPrompt: .asciz "Select grade of gas to dispense (R, M, or P): \n"
	@used to prompt the user for the type of gas they want 

.balign 16
strCashPrompt: .asciz "Enter Dollar amount to dispense (at least 1 and no more than 50): \n"
	@used to prompt the user for the cash amount they wish to spend

.balign 16
intRegular: .asciz "Regular     %d\n"
	@used to display inventories for regular gas
 
.balign 16
intMid: .asciz "Mid-Grade   %d\n"
	@used to display inventories for mid-grade gas
.balign 16
intPremium: .asciz "Premium     %d\n\n"
	@used to display inventories for premium gas


@recycled values
.balign 4
numInputPattern: .asciz "%d"  
	@ integer format for read.
.balign 4
charInputPattern: .asciz "$c"
 	@char format
.balign 4
strInputPattern: .asciz "%[^\n]" 
	@ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  
	@ User to clear the input buffer for invalid input.

.balign 4
intInput: .word 0   
	@ Location used to store the user input. 
.balign 4
charInput: .word '0'


.global printf
	@used to print  
.global scanf 
	@used to get user input

