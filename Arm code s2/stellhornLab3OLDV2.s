@ Benny Stellhorn
@ bas0042@uah.edu
@ CS413- 01- Fall 2021

.global main
main:

mov r9, #0	@r3 will be the user's total

mov r5, #2
mov r6, #2
mov r11, #2
mov r12, #2

prompt:		@ prompt user for an input
	ldr r0, =welcome
	bl printf
 	

	mov r5, #2	@gum
	mov r6, #2	@peanuts
	mov r11, #2	@crackers
	mov r12, #2	@m&ms




@******************
getInput: 
@******************
	
	
	ldr r0, =charInputPattern @needed to scanf an integer 
	ldr r1, =charInput                      	
	bl  scanf

	ldr r1, =charInput
	ldr r7, [r1]

	ldr r0, =confirmation
	bl printf
	

	ldr r0, =charInputPattern @needed to scanf an integer 
	ldr r1, =charInput                      	
	bl  scanf

	ldr r1, =charInput
	ldr r1, [r1]
	cmp r1, #'n'
	beq prompt
	

	cmp r7, #'g'
	beq gumPrompt
	cmp r7, #'p'
	beq peanutPrompt	
	cmp r7, #'c'
	beq crackerPrompt
	cmp r7, #'m'
	beq mmPrompt
	

b getInput

checkSelection:
	cmp r10, #1
	beq gumPrompt
	cmp r10, #2
	beq peanutPrompt
	cmp r10, #3
	beq crackerPrompt
	cmp r10, #4
	beq mmPrompt


gumPrompt:
	ldr r0, =gumstr
	bl printf
	mov r10, #1

gum:		
	cmp r5, #0
	beq out
	mov r4, #50 	@r4 will be the cost of the item
	ldr r0, =charInputPattern @needed to scanf an integer 
	ldr r1, =charInput                      	
	bl  scanf


	ldr r1, =charInput
	ldr r1, [r1]
	cmp r1, #'d'
	beq dime
	cmp r1, #'q'
	beq quarter
	cmp r1, #'b'
	beq bill
	
b gum

peanutPrompt:
	ldr r0, =gumstr
	bl printf
	mov r10, #2
	
peanut:		
	cmp r6, #0
	beq out
	mov r4, #55 	@r4 will be the cost of the item
	ldr r0, =charInputPattern @needed to scanf an integer 
	ldr r1, =charInput                      	
	bl  scanf


	ldr r1, =charInput
	ldr r1, [r1]
	cmp r1, #'d'
	beq dime
	cmp r1, #'q'
	beq quarter
	cmp r1, #'b'
	beq bill
	
b peanut

crackerPrompt:
	ldr r0, =gumstr
	bl printf
	mov r10, #3

cracker:	
	cmp r11, #0
	beq out	
	mov r4, #65 	@r4 will be the cost of the item
	ldr r0, =charInputPattern @needed to scanf an integer 
	ldr r1, =charInput                      	
	bl  scanf


	ldr r1, =charInput
	ldr r1, [r1]
	cmp r1, #'d'
	beq dime
	cmp r1, #'q'
	beq quarter
	cmp r1, #'b'
	beq bill
	
b cracker

mmPrompt:
	ldr r0, =gumstr
	bl printf
	mov r10, #4
	
mm:		
	cmp r12, #0
	beq out
	mov r4, #100 	@r4 will be the cost of the item
	ldr r0, =charInputPattern @needed to scanf an integer 
	ldr r1, =charInput                      	
	bl  scanf


	ldr r1, =charInput
	ldr r1, [r1]
	cmp r1, #'d'
	beq dime
	cmp r1, #'q'
	beq quarter
	cmp r1, #'b'
	beq bill
	
b mm

out:
	ldr r0, =outstr
	bl printf 
	b prompt

dime:
	ldr r0, =dimestr
	bl printf
	
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	
	ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                           @ it can be printed. 
	
	mov r2, #10
	mov r3, r1
	mul r8, r3, r2
	add r9, r8
	ldr r0, =strOutputNum 
	mov r1, r9
	cmp r9, r4
	bge printTotal
	b checkSelection

quarter:
	ldr r0, =quarterstr
	bl printf
	
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	
	ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                           @ it can be printed. 
	
	mov r2, #25
	mov r3, r1
	mul r8, r3, r2
	add r9, r8
	ldr r0, =strOutputNum 
	mov r1, r9
	cmp r9, r4
	bge printTotal
	b checkSelection


bill:
	ldr r0, =billstr
	bl printf
	
	ldr r0, =numInputPattern @ Setup to read in one number.
	ldr r1, =intInput        @ load r1 with the address of where the
                            @ input value will be stored. 	
	bl  scanf                @ scan the keyboard.
	
	ldr r1, =intInput        @ Have to reload r1 because it gets wiped out. 
	ldr r1, [r1]             @ Read the contents of intInput and store in r1 so that
                           @ it can be printed. 
	
	mov r2, #100
	mov r3, r1
	mul r8, r3, r2
	add r9, r8
	ldr r0, =strOutputNum 
	mov r1, r9
	cmp r9, r4
	bge printTotal
	b checkSelection


printTotal:
	mov r1, #1
	cmp r10, #1
	sub r5, r5, r1
	cmp r10, #2
	sub r6, r6, r1
	cmp r10, #3
	sub r11, r11, r1
	cmp r10, #4
	sub r12, r12, r1

	ldr r0, =totalstr 
	mov r1, r9
	bl printf	


change:
	rsb r1, r4, r9
	mov r9, #0
	ldr r0, =changeOutput 
	bl printf    
	b prompt



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
welcome: .asciz "Welcome to vending machine. \ng - Gum: $0.50\np - Peanuts: $0.55\nc - Cheese Crackers: $0.65\nm - M&Ms: $1.00\n"	

.balign 4
confirmation: .asciz "Are you sure? y/n\n"

.balign 4 
gumstr: .asciz "Please insert Payment.\nd - Dimes\nq - Quarters\nB - bills\n"

.balign 4 
totalstr: .asciz "You have inserted %d cents\n"

.balign 4 
dimestr: .asciz "Enter the number of dimes\n"

.balign 4 
quarterstr: .asciz "Enter the number of quarters\n"

.balign 4 
billstr: .asciz "Enter the number of bills\n"

.balign 4 
outstr: .asciz "Selection out of stock\n"

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
strOutputNum: .asciz "%d \n" 

.balign 4
changeOutput: .asciz "Change in cents:%d \n" 


.balign 4
cost: .word 0   

.balign 4
total: .word 0   
	@ Location used to store the user input. 
.balign 4
charInput: .word 0


.global printf
	@used to print  
.global scanf 
	@used to get user input
