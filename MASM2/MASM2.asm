;*************************************************************************************
; Program Name:  MASM2.asm
; Programmer:    Osvaldo Moreno Ornelas
; Class:         CS3B
; Date:          February 28 2017
; Purpose:
;        which will input numeric information from the keyboard, add, subtract,
;        multiply, and divide, as well as check for overflow and/or invalid
;        numeric information.
;
;*************************************************************************************
	.386
	.model flat;, stdcall
	.stack 100h

	intasc32Comma	PROTO Near32 stdcall, lpStringToHold:dword, dval:dword				 ;output number with commas
	hexToChar       PROTO Near32 stdcall, lpDestStr:dword, lpSourceStr:dword, dLen:dword ;convert hexadecimal to characters
	ExitProcess 	PROTO Near32 stdcall, dwExitCode:dword  							 ;capitalization not necessary
	putstring 		PROTO Near32 stdcall, lpStringToDisplay:dword						 ;displays null-terminated string
	ascint32		PROTO Near32 stdcall, lpStringToConvert:dword						 ;result in EAX
	intasc32		PROTO Near32 stdcall, lpStringToHold:dword, dNumToConvert:dword		 ;converts the int into asc 32
	getche		PROTO Near32 stdcall  ;returns character in the AL register
 	getch		PROTO Near32 stdcall  ;returns character in the AL register
	putch		PROTO Near32 stdcall, bChar:byte

	
	
	;variables declared below
	.data

	;do not use the microsoft flags!!!!!!!
	;use the ones in page 609 ( makes it harder )
	;cmp, dest, src  (dest-src) 
	;sub dest, src (dest-src)
	;INVOKE getch
	;cmp AL, 13 ; compare contents of the AL to 13(ascii value)
	;use ascii table for assignment
	;use ascii table to compare the data inputted to certain input values/actions
	;use AL register to store data and operations
	;slide 20 sum of PROC from powerpoint
	
	;getch
	;readValue:
		;cmp AL,13
		;JE Done
		;mov strptr[sCount], AL
		;jmp 
		;Done: 
		
	;sLimit = the maximum that is allowed ;allows for input restrictions
	;once string is input, convert to int from ascii
	
	;encouraged to not use PROC and COL
	;
	
	
  ;Student info
  headerStr   byte 9, "Name: Osvaldo Moreno Ornelas",
          13, 10, 9, "Class: CS3B",
          13, 10, 9, " Lab: MASM2.asm",
          13, 10, 9, " Date: 2/5/17",
          13, 10, 13, 10,0


	;ouputting message as a string	
	firstNumPromp byte 10,13, "Enter your first number: ",0
	secondNumPrompt byte 10,13, "Enter your first number: ",0	
	sumMessage byte 10,13, "The sum is: ",0	
	diffMessage byte 10,13, "The difference is ",0	
	productMessage byte 10,13, "The product is ",0	
	quatientMessage byte 10,13, "The quotient is: ",0
	remMessage byte 10,13, "The remainder is: ",0
	
	;error messages for output
	strOverflowAdd	byte 10,13,"OVERFLOW occurred when ADDING",0
	strOverflowSub	byte 10,13,"OVERFLOW occurred when SUBTRACTING",0
	strOverflowMul	byte 10,13,"OVERFLOW occurred when MULTIPLYING",0
	strOverflowConv	byte 10,13,"OVERFLOW occurred when CONVERTING",0
	strInvalidString	byte 10,13,"INVALID character in numeric string",0
	
	;value storing variables
	
	strInputOne 		byte 11 dup(?)
	strInputTwo		    byte 11 dup(?)
	
	strSpaceInput       byte 8,20,8

	;counter for the spaces
	dword counter 0
	
	strAddResult 		byte 15 dup(?)
	strSubResult 		byte 15 dup(?)
	strProductResult 	byte 15 dup(?)
	strQuotientResult 	byte 15 dup(?)
	strRemResult 		byte 15 dup(?)
	
	;6.3 conditional jumps
	;pg 202

;*********start the executable code here***************

   .code  ;here the code begins

 _start:
 
 ;get first input
 
 INVOKE putstring, ADDR firstNumPromp

 getFirstInput:
 	INVOKE getch				;store result in the AL
	CMP AL, 8 					;checks for backspace
	JNE issaBack



	

issaBack:
	INVOKE putstring, ADDR strSpaceInput
	
bareBack:
	CMP AL, 13 ;did the user input an enter
	JE exitProgram
	;JNE addNums 
	
	;if !JE
	MOV strInput[ESI], AL	;move contents of AL into the string input
	INC ESI
	DEC ECX
	
	

;get second input 
INVOKE putstring, ADDR secondNumPrompt
call getInputProc

 
 ;check if valid

 
 ;if not loop back
 
 
 
;do operations
addNums:


;error messages
issaAddOverflow:


issaSubOverflow:



issaMultOverflow:




issaConverOverflow:




;display outputs
 
 


exitProgram:




;******end statatements*************

 INVOKE ExitProcess,0	;exit program
 PUBLIC _start

getInputProc  proc 

	INVOKE getch				;store result in the AL
	CMP AL, 8 					;checks for backspace
	
	;6.3 conditional jumps
	;pg 202
	
	JNE bareBack
	
	;if inputted backspace
	;JE exitProgram
	
	RET
getInputProc  endp






 END

end					;here the program ends
