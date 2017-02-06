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
	

	
	.code  ;here the code begins
	
_start: 

	

		


		INVOKE ExitProcess,0
		PUBLIC _start
		END

	end					;here the program ends