;************************************************************************
; Program Name:		MASM3.asm
; Programmers:		Arang Christopher Montazer 
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

strName					byte	"OSvAlDo", 0
strCount				dword	?


		.code
_start:
	mov EAX, 0									; ensures first instruction can be executed in Ollydbg

	INVOKE putstring, ADDR strAssignmentHeader	; outputs assignment header
	
	INVOKE putstring, ADDR strCRLF
	
	push OFFSET strName
	
	call String_toLowerCase
	
	add esp, 4
	
	;INVOKE intasc32, ADDR strCount, EAX
	INVOKE putstring, EAX
	

	INVOKE ExitProcess, 0						; terminates program normally	
	PUBLIC _start

;+String_toLowerCase(string1:String):String  
;It converts the string to lower case string
String_toLowerCase proc Near32

push  ebp			;preserve
mov   ebp, esp		;stack frame
 
 push ebx		;word to be converted to lower case
 push esi 		;push counter
 
 mov esi, 0		;initialize to zero
 
 mov ebx, [ebp + 8] ;get data in that position and put into the ebx
 
 mainLoop:
 
 ;cmp ebx, 0			;if there is nothing
 
 cmp byte ptr [ebx + esi], 0
 JE endthepain		;end the procedure
 
 cmp byte ptr [ebx + esi], 91d    ;if less than 91 (have to use byte ptr because we are comparing byte vs byte)
 JB checklowerbound
 
 
 ;other wise just move past it to the next character
 
 inc esi						;increment counter
 JMP mainLoop 					;start the comparison again
 
 checklowerbound:
    cmp byte ptr [ebx + esi], 64d			;if greater than 64
	JA  convertToLower	;go to convert character
	
	;if not valid then just move past it
	;JMP endthepain
	
	inc esi
	JMP mainLoop
	
	;convert the character by adding 32 to it
 convertToLower:
	mov cl, [ebx + esi]
	add cl, 32
	mov [ebx + esi], cl
	
	inc esi
	JMP mainLoop
 
 ;finish the method
 endthepain:
 
	;add value into the eax
	
	mov eax, ebx
 
	pop esi
    pop ebx
	pop ebp
    
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
