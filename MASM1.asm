;*************************************************************************************
; Program Name:  MASM1.asm
; Programmer:    Osvaldo Moreno Ornelas
; Class:         CS3B
; Date:          February 1 2017
; Purpose:
;        To create a simple input/output program in Assembly languange
;
;*************************************************************************************  
	.486
	.model flat
	.stack 100h
	
	ExitProcess PROTO Near32 stdcall, dwExitCode:dword 					 ;capitalization not necessary
	getstring PROTO Near32 stdcall, lpStringToHold:dword, numChars:dword ; inputs max of numchars
	putstring PROTO Near32 stdcall, lpStringToDisplay:dword			     ;displays null-terminated string
	ascint32	PROTO Near32 stdcall, lpStringToConvert:dword			 ;result in EAX
	intasc32Comma	PROTO Near32 stdcall, lpStringToHold:dword, dNumToConvert:dword
	
	.data ;variables declared below
	
	;getting data as a string
	firstInput 	byte 16 dup(?)    ;declare new variable with no info inside and 16 bytes
	secondInput byte 16 dup(?)
	thirdInput 	byte 16 dup(?)
	fourthInput byte 16 dup(?)
	
	;passing to be integer
	firstInputNum 	dword  ?   ;double word with no value inside
	secondInputNum  dword  ? 
	thirdInputNum   dword  ? 
	fourthInputNum  dword  ?
	
	totalVal    byte 16 dup(?)   ;stores the result of the equation
	

	
	
	
	
	

	
	.code  ;here the code begins
	
_start: 
	
	;get data from the user
	
	;get first input
	INVOKE getstring, ADDR firstInput, 16    ;getstring and store it in the address of firstInput
	
	;get second input
	INVOKE getstring, ADDR secondInput, 16 
	INVOKE putstring, ADDR crlf          ;creates a newline (endl)
	
	;get third input
	INVOKE getstring, ADDR thirdInput, 16 
	
	;get fourth input
	INVOKE getstring, ADDR fourthInput, 16 
	INVOKE putstring, ADDR crlf
	
	;get data and parse it into an integer value in a separate variable/location
	
	INVOKE ascint32, ADDR firstInput
	mov firstInputNum, eax
	
	INVOKE ascint32, ADDR secondInput
	mov secondInputNum, eax
	
	INVOKE ascint32, ADDR thirdInput
	mov thirdInputNum, eax
	
	INVOKE ascint32, ADDR fourthInput
	mov fourthInputNum, eax
	
	
	
	
	
	

		


		INVOKE ExitProcess,0
		PUBLIC _start
		END

	end					;here the program ends