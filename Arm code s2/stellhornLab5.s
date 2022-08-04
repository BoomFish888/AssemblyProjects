@ Benny Stellhorn
@ bas0042@uah.edu
@ CS413- 01- Fall 2021

OUTPUT = 1 @ Used to set the selected GPIO pins to output only. 
INPUT  = 0  

PUD_UP   = 2  
PUD_DOWN = 1 

LOW  = 0 
HIGH = 1
INPUT  = 0  

PUD_UP   = 2  
PUD_DOWN = 1 

LOW  = 0 
HIGH = 1


.text

.balign 4

.global main
main:

	
mov r9, #0
mov r5, #2
mov r6, #2
mov r11, #2
mov r8, #2






@    r0 - contains the pass/fail code
 

       bl      wiringPiSetup

        mov     r1,#-1

        cmp     r0, r1

        bne     init  @ Everything is OK so continue with code.

        ldr     r0, =ErrMsg

        bl      printf

        b       myexit  @ There is a problem with the GPIO exit code.

@
@ Set four of the GPIO pins to output
@

@ set the mode to input-BLUE
init:

        ldr     r0, =buttonBlue
        ldr     r0, [r0]
        mov     r1, #INPUT
        bl      pinMode

@ set the mode to input - GREEN

        ldr     r0, =buttonGreen
        ldr     r0, [r0]
        mov     r1, #INPUT
        bl      pinMode

@ set the mode to input- YELLOW

        ldr     r0, =buttonYellow
        ldr     r0, [r0]
        mov     r1, #INPUT
        bl      pinMode

@ set the mode to input - RED

        ldr     r0, =buttonRed
        ldr     r0, [r0]
        mov     r1, #INPUT
        bl      pinMode

 
@ Setup and read all the buttons. 
@ Set the buttons for pull-up and it is 0 when pressed. 
@    pullUpDnControl(buttonPin, PUD_UP)
@    digitalRead(buttonPin) == LOW button pressed
@
    ldr  r0, =buttonBlue
    ldr  r0, [r0]
    mov  r1, #PUD_UP
    BL   pullUpDnControl 

    ldr  r0, =buttonGreen
    ldr  r0, [r0]
    mov  r1, #PUD_UP
    BL   pullUpDnControl 

    ldr  r0, =buttonYellow
    ldr  r0, [r0]
    mov  r1, #PUD_UP
    BL   pullUpDnControl 

    ldr  r0, =buttonRed
    ldr  r0, [r0]
    mov  r1, #PUD_UP
    BL   pullUpDnControl 

@ set the pin2 mode to output

        ldr     r0, =pin2

        ldr     r0, [r0]

        mov     r1, #OUTPUT

        bl      pinMode


@ set the pin3 mode to output


        ldr     r0, =pin3

        ldr     r0, [r0]

        mov     r1, #OUTPUT

        bl      pinMode


@ set the pin4 mode to output


        ldr     r0, =pin4
        ldr     r0, [r0]

        mov     r1, #OUTPUT

        bl      pinMode


@ set the pin5 mode to output


        ldr     r0, =pin5

        ldr     r0, [r0]

        mov     r1, #OUTPUT

        bl      pinMode
 


@***************
fiveSecondRed:
@****************


@ Write a logic one to turn pin5 to on.


        ldr     r0, =pin5

        ldr     r0, [r0]
        mov     r1, #1

        bl      digitalWrite


ldr     r0, =delayFive

        ldr     r0, [r0]

        bl      delay


@ Write a logic 0 to turn pin5 off.
 
       ldr     r0, =pin5

        ldr     r0, [r0]

        mov     r1, #0

        bl      digitalWrite


prompt:		@ prompt user for an input
	
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


	ldr r0, =welcome
	bl printf

@******************
getInput: 
@******************

	push {r8, r9, r10, r11}
	
	mov r8,  #0xff 
    	mov r9,  #0xff
    	mov r10, #0xff    
    	mov r11, #0xff 

ButtonLoop:
@ Delay a few miliseconds to help debounce the switches. 
@
    ldr  r0, =delayMs
    ldr  r0, [r0]
    BL   delay

ReadBLUE:
@ Read the value of the blue button. If it is HIGH (i.e., not
@ pressed) read the next button and set the previous reading
@ value to HIGH. 
@ Otherwise the current value is LOW (pressed). If it was LOW
@ that last time the button is still pressed down. Do not record
@ this as a new pressing.
@ If it was HIGH the last time and LOW now then record the 
@ button has been pressed.
@
    ldr    r0,  =buttonBlue
    ldr    r0,  [r0]
    BL     digitalRead 
    cmp    r0, #HIGH   @ Button is HIGH read next button
    moveq  r9, r0      @ Set last time read value to HIGH 
    beq    ReadGREEN

    @ The button value is LOW.
    @ If it was LOW the last time it is still down. 
    cmp    r9, #LOW    @ was the last time it was called also
                       @ down?
    beq    ReadGREEN   @ button is still down read next button
                       @ value. 
     
    mov    r9, r0  @ This is a new button press. 
    mov r7, #'m'
    pop {r8, r9, r10, r11}
    b      mmPrompt @ Branch to print the blue button was pressed. 

ReadGREEN:
@ See comments on BLUE button on how this code works. 
@
    ldr    r0,  =buttonGreen
    ldr    r0,  [r0]
    BL     digitalRead  
    cmp    r0, #HIGH
    moveq  r10, r0
    beq    ReadYELLOW   

    cmp    r10, #LOW
    beq    ReadYELLOW  

    mov    r10, r0
    mov r7, #'c'
    pop {r8, r9, r10, r11}
    b      crackerPrompt 

ReadYELLOW:
@ See comments on BLUE button on how this code works. 
@
    ldr    r0,  =buttonYellow
    ldr    r0,  [r0]
    BL     digitalRead 
    cmp    r0, #HIGH
    moveq  r11, r0
    beq    ReadRED 
 
    cmp    r11, #LOW
    beq    ReadRED

    mov    r11, r0
    mov r7, #'p'
    pop {r8, r9, r10, r11}
    b      peanutPrompt 

ReadRED:
@ See comments on BLUE button on how this code works. 
@
    ldr    r0,  =buttonRed
    ldr    r0,  [r0]
    BL     digitalRead 
    cmp    r0, #HIGH
    moveq  r8, r0
    beq    ButtonLoop
 
    cmp    r8, #LOW
    beq    ButtonLoop
 
    mov    r8, r0
    mov r7, #'g'
    pop {r8, r9, r10, r11}
    b      gumPrompt

	
	/*ldr r0, =charInputPattern @needed to scanf an integer 
	ldr r1, =charInput                      	
	bl  scanf
	
	@ldr r7, =userSelection
	@ldr r1, =charInput
	@ldr r1, [r1]
	@str r1, [r7]

	
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
	*/

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
	
	ldr r4, =cost
	mov r3, #50
	str r3, [r4]

	
	@ ldr r0, =numInputPattern
	@ ldr r1, =cost
	@ ldr r1, [r1]
	@ bl printf

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

	ldr r4, =cost
	mov r3, #55
	str r3, [r4]

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
	ldr r4, =cost
	mov r3, #65
	str r3, [r4]
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
	ldr r4, =cost
	mov r3, #100
	str r3, [r4]
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
	ldr r4, =cost
	ldr r4, [r4]
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
	ldr r4, =cost
	ldr r4, [r4]
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
	ldr r4, =cost
	ldr r4, [r4]
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
	ldr r4, =cost
	ldr r4, [r4]
	rsb r1, r4, r9
	mov r9, #0
	ldr r0, =changeOutput 
	bl printf 
	
	mov r1, #0 
	  
@check input and flash correct LED

dispense:
	mov r9, #3
	cmp r7, #'g'
	beq gumFlash
	cmp r7, #'p'
	beq peanutFlash	
	cmp r7, #'c'
	beq crackerFlash
	cmp r7, #'m'
	beq mmFlash

	b prompt
gumFlash:

	@ Write a logic one to turn pin5 to on.

        ldr     r0, =pin5

        ldr     r0, [r0]
        mov     r1, #1

        bl      digitalWrite


	ldr     r0, =delayOne

        ldr     r0, [r0]

        bl      delay


	@ Write a logic 0 to turn pin5 off.
 
        ldr     r0, =pin5

        ldr     r0, [r0]

        mov     r1, #0

        bl      digitalWrite

	ldr     r0, =delayOne

        ldr     r0, [r0]

        bl      delay

	sub r9, #1
	cmp r9, #0
	bne gumFlash

	@ Write a logic one to turn pin5 to on.


        ldr     r0, =pin5

        ldr     r0, [r0]
        mov     r1, #1

        bl      digitalWrite


	ldr     r0, =delayFive

        ldr     r0, [r0]

        bl      delay


	@ Write a logic 0 to turn pin5 off.
 
        ldr     r0, =pin5

        ldr     r0, [r0]

        mov     r1, #0

        bl      digitalWrite

	b prompt

peanutFlash:

	@ Write a logic one to turn pin4 to on.

        ldr     r0, =pin4

        ldr     r0, [r0]
        mov     r1, #1

        bl      digitalWrite


	ldr     r0, =delayOne

        ldr     r0, [r0]

        bl      delay


	@ Write a logic 0 to turn pin4 off.
 
       ldr     r0, =pin4

        ldr     r0, [r0]

        mov     r1, #0

        bl      digitalWrite

	ldr     r0, =delayOne

        ldr     r0, [r0]

        bl      delay

	sub r9, #1
	cmp r9, #0
	bne peanutFlash

	@ Write a logic one to turn pin5 to on.


        ldr     r0, =pin4

        ldr     r0, [r0]
        mov     r1, #1

        bl      digitalWrite


	ldr     r0, =delayFive

        ldr     r0, [r0]

        bl      delay


	@ Write a logic 0 to turn pin4 off.
 
       ldr     r0, =pin4

        ldr     r0, [r0]

        mov     r1, #0

        bl      digitalWrite

	b prompt

crackerFlash:

	@ Write a logic one to turn pin3 to on.

        ldr     r0, =pin3

        ldr     r0, [r0]
        mov     r1, #1

        bl      digitalWrite


	ldr     r0, =delayOne

        ldr     r0, [r0]

        bl      delay


	@ Write a logic 0 to turn pin3 off.
 
        ldr     r0, =pin3

        ldr     r0, [r0]

        mov     r1, #0

        bl      digitalWrite

	ldr     r0, =delayOne

        ldr     r0, [r0]

        bl      delay

	sub r9, #1
	cmp r9, #0
	bne crackerFlash

	@ Write a logic one to turn pin5 to on.


        ldr     r0, =pin3

        ldr     r0, [r0]
        mov     r1, #1

        bl      digitalWrite


	ldr     r0, =delayFive

        ldr     r0, [r0]

        bl      delay


	@ Write a logic 0 to turn pin5 off.
 
        ldr     r0, =pin3

        ldr     r0, [r0]

        mov     r1, #0

        bl      digitalWrite

	b prompt

mmFlash:

	@ Write a logic one to turn pin5 to on.

        ldr     r0, =pin2

        ldr     r0, [r0]
        mov     r1, #1

        bl      digitalWrite


	ldr     r0, =delayOne

        ldr     r0, [r0]

        bl      delay


	@ Write a logic 0 to turn pin5 off.
 
        ldr     r0, =pin2

        ldr     r0, [r0]

        mov     r1, #0

        bl      digitalWrite

	ldr     r0, =delayOne

        ldr     r0, [r0]

        bl      delay

	sub r9, #1
	cmp r9, #0
	bne mmFlash

	@ Write a logic one to turn pin5 to on.


        ldr     r0, =pin2

        ldr     r0, [r0]
        mov     r1, #1

        bl      digitalWrite


	ldr     r0, =delayFive

        ldr     r0, [r0]

        bl      delay


	@ Write a logic 0 to turn pin5 off.
 
        ldr     r0, =pin2

        ldr     r0, [r0]

        mov     r1, #0

        bl      digitalWrite

	b prompt

cleanedOut:
	ldr r0, =endstr
	bl printf

@ Write a logic one to turn pin5 to on.


        ldr     r0, =pin5

        ldr     r0, [r0]
        mov     r1, #1

        bl      digitalWrite


ldr     r0, =delayFive

        ldr     r0, [r0]

        bl      delay


@ Write a logic 0 to turn pin5 off.
 
       ldr     r0, =pin5

        ldr     r0, [r0]

        mov     r1, #0

        bl      digitalWrite




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

delayFive: .word 5000  @ Set delay for 5 seconds. 

delayOne: .word 1000  @ Set delay for 1 second. 



buttonBlue:   .word 7 @Blue button
buttonGreen:  .word 0 @Green button
buttonYellow: .word 6 @Yellow button
buttonRed:    .word 1 @Red button

delayMs: .word 250  @ Delay time in Miliseconds.

.balign 4
string1: .asciz "Raspberry Pi Button Example with Assembly. \n"
.balign 4
string1a: .asciz "Circuit Board Example. \n" 
.balign 4
stringPressAny: .asciz "Press any of the buttons (Blue, Green, Yellow, or Red. \n"
.balign 4
string2: .asciz "Hardware error in GPIO see GTA. \n"

.balign 4
PressedBLUE: .asciz "The BLUE button was pressed. \n"
.balign 4
PressedYELLOW: .asciz "The YELLOW button was pressed.\n"
.balign 4
PressedGREEN: .asciz "The GREEN button was pressed. \n"
.balign 4
PressedRED:  .asciz "The RED button was pressed. \n"


pin2: .word 2 

pin3: .word 3

pin4: .word 4

pin5: .word 5


ErrMsg: .asciz "Setup didn't work... Aborting...\n"

.balign 4
welcome: .asciz "Welcome to vending machine. \nRed - Gum: $0.50\nYellow - Peanuts: $0.55\nGreen - Cheese Crackers: $0.65\nBlue - M&Ms: $1.00\n"	

.balign 4
confirmation: .asciz "Are you sure? y/n\n"

.balign 4 
gumstr: .asciz "Please insert Payment.\nd - Dimes\nq - Quarters\nb - bills\n"

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
userSelection: .skip 1     

.balign 4
total: .word 0   
	@ Location used to store the user input. 
.balign 4
charInput: .word 0

.extern wiringPiSetup 

.extern delay

.extern digitalWrite

.extern pinMode


.global printf
	@used to print  
.global scanf 
	@used to get user input
