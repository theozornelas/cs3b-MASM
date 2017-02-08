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
	intasc32	PROTO Near32 stdcall, lpStringToHold:dword, dNumToConvert:dword
	
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

	INVOKE getstring, ADDR firstInput    ;getstring and store it in the address of firstInput
	INVOKE getstring, ADDR secondInput
	INVOKE putstring, ADDR crlf          ;creates a newline (endl)
	INVOKE getstring, ADDR thirdInput
	INVOKE getstring, ADDR fourthInput
	
	
	
	

		


		INVOKE ExitProcess,0
		PUBLIC _start
		END

	end					;here the program ends