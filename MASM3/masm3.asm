;************************************************************************
; Program Name:		MASM3.asm
; Programmers:		Arang Christopher Montazer & Osvaldo Moreno Ornelas
; Class: 			CS3B
; Date:				3-28-17
; 
; Purpose:			string methods
;************************************************************************

		.486
		.model flat
		.stack 100h

		EXTERN String_equals:Near32
		EXTERN String_charAt:Near32
		EXTERN String_startsWith_1:Near32
		EXTERN String_startsWith_2:Near32
		EXTERN String_endsWith:Near32
		
		ExitProcess 		PROTO Near32 stdcall, dwExitCode:dword
		ascint32			PROTO Near32 stdcall, lpStringToConvert:dword
		intasc32			PROTO Near32 stdcall, lpStringToHold:dword, dval:dword
		getstring			PROTO Near32 stdcall, lpStringToGet:dword, dlength:dword
		putstring			PROTO Near32 stdcall, lpStringToPrint:dword
		getche				PROTO Near32 stdcall  ; returns character in the AL register
		getch				PROTO Near32 stdcall  ; returns character in the AL register
		putch				PROTO Near32 stdcall, bChar:byte
		memoryallocBailey	PROTO Near32 stdcall, dNumBytes:dword
		
		
		.data
strAssignmentHeader		byte	13, 10,	9,									
								"Name:       Arang Christopher Montazer",		
								13, 10, 9, 
								"Program:    MASM3.asm", 
								13, 10, 9, 
								"Class:      CS3B", 
								13, 10, 9, 
								"Date:       March 28, 2017", 
								13, 10, 13, 10, 0
	
	
strCRLF					byte	13, 10, 0
strBackspace			byte	8, 32, 8, 0

string1					byte	12 dup (?)
suffix					byte	12 dup (?)
result					dword	?


		.code
_start:
	mov EAX, 0									; ensures first instruction can be executed in Ollydbg

	INVOKE putstring, ADDR strAssignmentHeader	; outputs assignment header
	
	INVOKE putstring, ADDR strCRLF

	INVOKE getstring, ADDR string1, 12
	INVOKE putstring, ADDR strCRLF
	INVOKE getstring, ADDR suffix, 12
	INVOKE putstring, ADDR strCRLF
	
	push OFFSET suffix
	push OFFSET string1
	call String_endsWith
	add ESP, 8
	
	movsx EAX, AL
	INVOKE intasc32, ADDR result, EAX
	INVOKE putstring, ADDR result
	

	INVOKE ExitProcess, 0						; terminates program normally	
	
	PUBLIC _start

;	+String_length(string1:String):int
String_length	PROC Near32
	push ebp					; preserve base register
	mov  ebp,esp				; set new stack frame
	push ebx					; preserve used registers
	push esi
	mov  ebx,[ebp+8]			; ebx-> 1st string
	mov  esi,0					; esi indexes into the strings
	
stLoop:
	cmp byte ptr[ebx+esi], 0	; reached the end of the string
	je  finished				; if yes, done in here
	inc esi						; otherwise, continue to next character
	jmp stLoop					; until you hit the NULL character

finished:
	mov eax,esi					; returns the length in EAX
	pop esi						; restore preserved registers
	pop ebx
	pop ebp
	RET
String_length ENDP
	
	END
