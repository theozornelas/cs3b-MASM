;************************************************************************
; Program Name:		MASM4.asm
; Programmers:		Osvaldo Moreno Ornelas
; Class: 			CS3B
; Date:				TBD
; 
; Purpose:			 creating a Menu driver program that allows the user 
;					 to test all of your string macros that you created 
;					 for MASM3 plus some additional functionality.
;************************************************************************

		.486
		
		INCLUDE Irvine32.inc
		INCLUDE macros.inc
		includelib Irvine32.lib
		includelib kernel32.lib
		includelib user32.lib

		;****************************
		;*  String1.asm Procedures  *
		;****************************	
		; EXTERN String_equals:Near32
		; EXTERN String_charAt:Near32
		; EXTERN String_startsWith_1:Near32
		; EXTERN String_startsWith_2:Near32
		; EXTERN String_endsWith:Near32
		
		; ;****************************
		; ;*  String2.asm Procedures  *
		; ;****************************	
		; EXTERN String_toLowerCase:Near32
		; EXTERN String_indexOf_1:Near32
		; EXTERN String_toUpperCase:Near32
		; EXTERN String_indexOf_2:Near32
		; EXTERN String_indexOf_3:Near32
		; EXTERN String_concat:Near32
		; EXTERN String_replace:Near32
		; EXTERN String_lastIndexOf_1:Near32
		; EXTERN String_lastIndexOf_2:Near32
		; EXTERN String_lastIndexOf_3:Near32

		
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

	D_MAX_STRING_LEN = 32

	
	strChoice					byte 11 dup(?)
	dChoice						dword  ?
	
	bWordArray					byte 1280 dup(?)
	
		.code
_start:
	mov EAX, 0									; ensures first instruction can be executed in Ollydbg

	;Here we change the console color


	
	call output_header
beginning:
	;call Clrscr
	
	call output_menu
	
	INVOKE getstring, ADDR strChoice, 32
	INVOKE ascint32,  ADDR strChoice
	mov dChoice, eax
	
	push dChoice
	call dwordErrorCheck
	add esp, 4
	
	cmp eax, -1
	JE  invalidMessage

	cmp eax, 7
	JE endprogram
	
	cmp eax, 1
	JE  viewAll
	
	cmp eax, 2
	JE  addString
	
	cmp eax, 3
	JE deleteString
	
	cmp eax, 4
	JE editString
	
	cmp eax, 5
	JE stringSearch
	
	cmp eax, 6
	JE memoryConsuuption
	
	;more stuff to come in this section
	
viewAll:
	
	call Crlf
	mWrite "Displaying all Strings: "
	call Crlf
	JMP beginning
	
addString:
	
	call Crlf
	mWrite "Enter a new String: "
	call Crlf
	JMP beginning
	
deleteString:
	
	call Crlf
	mWrite "What string you want to delete? "
	call Crlf
	JMP beginning
	
editString:
	
	call Crlf
	mWrite "What string you want to edit? "
	call Crlf
	JMP beginning
	
stringSearch:
	
	call Crlf
	mWrite "What string you want to search? "
	call Crlf
	JMP beginning
	
memoryConsuuption:
	
	call Crlf
	mWrite "The memory consumption is currently: "
	call Crlf
	JMP beginning


invalidMessage:

	call Crlf
	mWrite "Invalid Input. Please input a number between 1 and 7"
	
	JMP beginning
	
issavalid:

	call Crlf
	mWrite "Valid Data Inputted"
	;call Clrscr
	JMP beginning
	
	;225 if else 
	
endprogram:
	call Crlf
	mWrite "Thank You, have an average day!"
	
;**********************END OF MAIN**********************

	
	INVOKE ExitProcess, 0						; terminates program normally	
	
	PUBLIC _start

;**********************************************************
;The following procedures are used to do the required
;operations for this assignment
;**********************************************************
	
;**********************************************************
;This procedure is to error check the user option
;**********************************************************
Display_Array PROC Near32
	push ebp		
	mov ebp, esp

	push ebx				;stores the array
	push esi 				;counter
	
	mov ebx, [ebp + 8]
	mov esi, 0
	
	
	mWrite "String #: "
	;push esi

endProc:

	pop esi
	pop ebx
	pop ebp

	RET

Display_Array endp	

;**********************************************************
;This procedure is to add a string to the array
;**********************************************************	
Add_String PROC Near32



Add_String endp

;**********************************************************
;This procedure is to delete a string to the array
;**********************************************************	
Delete_String PROC Near32


Delete_String endp
	
;**********************************************************
;The following procedures are used to add a user interface
;that allows the user to use the program with ease.
;**********************************************************	

;**********************************************************
;This procedure is to error check the user option
;**********************************************************
dwordErrorCheck PROC Near32

	push ebp
	mov ebp, esp
	push ebx
	
	
	mov ebx, [ebp + 8]	;the dword into the ebx
	
;if greater than 0	
checkLower:
	cmp ebx, 0
	JA checkupper
	
	JMP invalid
	
;if less than 8
checkupper:
	cmp ebx, 8
	JB  endthepain
	
	
invalid:
	mov ebx, -1
	
	
endthepain:
	mov eax, ebx
	pop ebx
	pop ebp

	RET
	
dwordErrorCheck endp
	
;**********************************************************
;+String_length(string1:String):int
;**********************************************************
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

;**********************************************************
;This procedure outputs the user menu to the console
;**********************************************************
output_menu PROC Near32

	call Crlf
	mWrite  "***************************************"
	call Crlf
	mWrite  "*           PROGRAM OPTIONS           *"
	call Crlf
	mWrite  "***************************************"
	call Crlf
	mWrite	"* <1> View all Strings                *"
	call Crlf
	mWrite  "* <2> Add String                      *"
	call Crlf
	mWrite	"* <3> Delete String                   *"
	call Crlf
	mWrite	"* <4> Edit String                     *"
	call Crlf
	mWrite	"* <5> String Search                   *"
	call Crlf
	mWrite	"* <6> String Array Memory Consuption  *"
	call Crlf
	mWrite	"* <7> Quit                            *"
	call Crlf
	mWrite	"***************************************"
	call Crlf
	mWrite  "Enter your choice:  "

	RET
output_menu endp

output_header PROC Near32

	call Crlf							
	mWrite "Name:       Osvaldo Moreno Ornelas"		
	call Crlf	
	mWrite "Program:    MASM4.asm" 
	call Crlf	
	mWrite "Class:      CS3B" 
	call Crlf	
	mWrite "Date:       TBD" 
	call Crlf	

	RET
	
output_header endp

	END
