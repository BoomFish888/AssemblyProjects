@ Benny Stellhorn
@ bas0042@uah.edu
@ CS413- 01- Fall 2021

.global main
main:

mov r9, #0	@r3 will be the user's total

mov r5, #2
mov r6, #2
mov r11, #2
mov r8, #2

prompt:		@ prompt user for an input
	ldr r0, =welcome
	bl printf

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
	cmp r7, #'i'
	b inventory
	

b getInput

inventory:
	ldr r0, =gumIstr
	mov r1, r5
	bl printf
	
	ldr r0, =nutIstr
	mov r1, r6
	bl printf
	
	ldr r0, =crackerIstr
	mov r1, r11
	bl printf
	
	ldr r0, =mmIstr
	mov r1, r8
	bl printf
	
	b prompt
	
	

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
	ble out
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
	ble out
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
	ble out	
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
	cmp r8, #0
	ble out
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
	mul r1, r3, r2
	add r9, r1
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
	mul r1, r3, r2
	add r9, r1
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
	mul r1, r3, r2
	add r9, r1
	ldr r0, =strOutputNum 
	mov r1, r9
	cmp r9, r4
	bge printTotal
	b checkSelection


printTotal:

	cmp r10, #1
	subeq r5, #1
	cmp r10, #2
	subeq r6, #1
	cmp r10, #3
	subeq r11, #1
	cmp r10, #4
	subeq r8, #1

	ldr r0, =totalstr 
	mov r1, r9
	bl printf	


change:
	rsb r1, r4, r9
	mov r9, #0
	ldr r0, =changeOutput 
	bl printf 
	
	@if empty then exit
	
	mov r1, #0
	
	cmp r5, #0
	addeq r1, #1
	cmp r6, #0
	addeq r1, #1
	cmp r11, #0
	addeq r1, #1
	cmp r8, #0
	addeq r1, #1
	
	cmp r1, #4
	beq cleanedOut  
	  
	b prompt

cleanedOut:
	ldr r0, =endstr
	bl printf


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
gumIstr: .asciz "Gums remaining: %d\n"

.balign 4 
nutIstr: .asciz "Peanuts remaining: %d\n"

.balign 4 
crackerIstr: .asciz "Crackers remaining: %d\n"

.balign 4 
mmIstr: .asciz "M&Ms remaining: %d\n"

.balign 4 
endstr: .asciz "Vending machine out of stock\n"


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
charInputPattern: .asciz "%s"
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
