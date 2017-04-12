;************************************************************************
; Program Name:		MASM3.asm
; Programmers:		Arang Christopher Montazer & Osvaldo Moreno Ornelas
; Class: 			CS3B
; Date:				3-28-17
; 
; Purpose:			string methods
;************************************************************************

		.486
		.model flat, stdcall
		.stack 100h

		ExitProcess 		PROTO Near32 stdcall, dwExitCode:dword
		ascint32			PROTO Near32 stdcall, lpStringToConvert:dword
		intasc32			PROTO Near32 stdcall, lpStringToHold:dword, dval:dword
		putstring			PROTO Near32 stdcall, lpStringToPrint:dword
		getche				PROTO Near32 stdcall  ; returns character in the AL register
		getch				PROTO Near32 stdcall  ; returns character in the AL register
		putch				PROTO Near32 stdcall, bChar:byte
		memoryallocBailey	PROTO Near32 stdcall, dNumBytes:dword
		
		
		.data
strAssignmentHeader		byte	13, 10,	9,									
								"Name:       Osvaldo Moreno Ornelas",		
								13, 10, 9, 
								"Program:    MASM2.asm", 
								13, 10, 9, 
								"Class:      CS3B", 
								13, 10, 9, 
								"Date:       February 22, 2017", 
								13, 10, 13, 10, 0
	
	
strCRLF					byte	13, 10, 0
strBackspace			byte	8, 32, 8, 0

strName					byte	"oSvAlDo", 0
strCount				dword	?


		.code
_start:
	mov EAX, 0									; ensures first instruction can be executed in Ollydbg

	;INVOKE putstring, ADDR strAssignmentHeader	; outputs assignment header
	
	;INVOKE putstring, ADDR strCRLF
	
	push OFFSET strName
	call String_toLowerCase
	add esp, 4
	
	;INVOKE intasc32, ADDR strCount, EAX
	;INVOKE putstring, ADDR strCount
	

	INVOKE ExitProcess, 0						; terminates program normally	
	PUBLIC _start

;+String_toUpperCase(string1:String):String   
;It converts the string to upper case string

String_toLowerCase proc Near3

push  ebp
mov   ebp, esp
 
 push eax  		;push string in
 push ebx
 push esi 		;start counter
 
 mov esi, 0		;initialize to zero
 
 mainLoop:
 
 mov eax, 91    ;if less than 91
 JB checkupper
 
 checkupper:
    cmp eax, 64			;if greater than 64
	JA  convertToLower	;go to convert character
	
	JMP endthepain
	
	;convert the character by adding 32 to it
 convertToLower:
	mov bl, byte ptr [eax + esi] + 32
 
 ;finish the method
 endthepain:
	;mov al, esi
    pop eax
    ;pop bx
    pop esi
 
 RET 
 
String_toLowerCase endp
	
	
String_length	proc Near32
	push ebp					; preserve base register
	mov ebp,esp					; set new stack frame
	push ebx					; preserve used registers
	push esi
	mov ebx,[ebp+8]				; ebx-> 1st string
	mov esi,0					; esi indexes into the strings
	
stLoop:
	cmp byte ptr[ebx+esi],0		; reached the end of the string
	je finished					; if yes, done in here
	inc esi						; otherwise, continue to next character
	jmp stLoop					; until you hit the NULL character

finished:
	mov eax,esi					; returns the length in EAX
	pop esi						; restore preserved registers
	pop ebx
	pop ebp
	RET
String_length endp
	
	END
