@ Benny Stellhorn
@ bas0042@uah.edu
@ CS413- 01- Fall 2021




.global main
main:

ldr r0, =array1
ldr r1, =array2
ldr r2, =sumarray
mov r3, #1	@counter


loop:
	
	ldr r4, [r0], #4	@increment array1 by 4 bytes
	ldr r5, [r1], #4	@increment array2 by 4 bytes
	add r6, r4, r5		@load the sum into sum array
	str r6, [r2], #4	@increment sum array by 4 bytes
	add r3, #1		@increment counter
	cmp r3, #10
	bne loop

printarrays:
   ldr r0, =array1str 
   bl  printf           
   ldr r1, =array1
   push {r1}
   bl printa
   ldr r0, =array2str 
   bl  printf  
   ldr r1, =array2
   push {r1}
   bl printa
   ldr r0, =array3str 
   bl  printf  
   ldr r1, =sumarray
   push {r1}
   bl printa

@taken from helloworld
@*******************
prompter:
@*******************

@ Ask the user to enter a number.
 
   ldr r0, =prompt @ Put the address of my string into the first parameter
   bl  printf              @ Call the C printf to display input prompt. 

@*******************
get_input:
@*******************

@ Set up r0 with the address of input pattern.
@ scanf puts the input value at the address stored in r1. We are going
@ to use the address for our declared variable in the data section - intInput. 
@ After the call to scanf the input is at the address pointed to by r1 which 
@ in this case will be intInput. 

   ldr r0, =numInputPattern @ Setup to read in one number.
   ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 
   bl  scanf                @ scan the keyboard.
   ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
   ldr r7, [r1]             @ Read the contents of intInput and store in r1 so that
                            @ it can be printed. 
  mov r6, #1 @ for i =1
  ldr r5, =sumarray

loop2:
  ldr r1, [r5], #4  
  cmp r6, #11
  bge exitloop
  
  cmp r7, #1  @ print positive array
  bne zero
  cmp r1, #0 
  bgt printele
  b   nextele

zero:
  cmp r7, #2 @ print zero array
  bne neg
  cmpeq r1, #0
  beq printele
  b   nextele

neg:
  cmp r1, #0
  bmi printele
  b nextele

printele:
  ldr r0, =strOutputNum
  bl  printf

nextele:
  add r6, r6, #1
  b loop2

exitloop:

   b   myexit 
 

printa:
  pop  {r5} 
  push {lr}  
  ldr  r1, [r5] 
  mov  r6, #1   
printl:
   cmp r6, #11
   bge exitprint
   ldr r1, [r5]
   ldr r0, =strOutputNum
   bl  printf
   add r5, r5, #4 @ go to the next word. 
   add r6, r6, #1
   b printl
exitprint:
   pop {pc} 

myexit:	
	mov r7, #0x01
	svc 0
	
.data 
.balign 4
welcome: .asciz "Welcome to lab 1"

.balign 4
sumarray: .skip 40 

.balign 4
array1: .word 2,3,4,5,6,7,8,9,10,11

.balign 4
array2: .word 1,-2, 4, -6,  8,-10, 12, -14,  16, -18

.balign 4
prompt: .asciz "Enter 1 for all positive values, 2 for all zero values, or 3 for all negative values\n"

.balign
array1str: .asciz "Array 1\n"

.balign 4
array2str: .asciz "Array 2\n"

.balign 4
array3str: .asciz "Array 3\n"

@taken from hello world
.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 

.balign 4
strOutputNum: .asciz " %d \n"

.balign 4
intInput: .word 0   @ Location used to store the user input. 



.global printf
.global scanf
