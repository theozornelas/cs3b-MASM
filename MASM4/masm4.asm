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
		.model flat
		.stack 100h

		;****************************
		;*  String1.asm Procedures  *
		;****************************	
		EXTERN String_equals:Near32
		EXTERN String_charAt:Near32
		EXTERN String_startsWith_1:Near32
		EXTERN String_startsWith_2:Near32
		EXTERN String_endsWith:Near32
		
		;****************************
		;*  String2.asm Procedures  *
		;****************************	
		EXTERN String_toLowerCase:Near32
		EXTERN String_indexOf_1:Near32
		EXTERN String_toUpperCase:Near32
		EXTERN String_indexOf_2:Near32
		EXTERN String_indexOf_3:Near32
		EXTERN String_concat:Near32
		EXTERN String_replace:Near32
		EXTERN String_lastIndexOf_1:Near32
		EXTERN String_lastIndexOf_2:Near32
		EXTERN String_lastIndexOf_3:Near32

		
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
									"Name:       Osvaldo Moreno Ornelas",		
									13, 10, 9, 
									"Program:    MASM4.asm", 
									13, 10, 9, 
									"Class:      CS3B", 
									13, 10, 9, 
									"Date:       TBD", 
									13, 10, 13, 10, 0
		
		
	crlf					byte	13, 10, 0
	strBackspace			byte	8, 32, 8, 0

	D_MAX_STRING_LEN = 32

	;message and prompts for String_length
	strTestingStringLength	byte	"*************************************", 13, 10,
									"*       USING String_length       *", 13, 10,
									"*************************************", 13, 10, 0
	strStrLengthPrompt		byte	"Enter a string:               ", 0
	strStrLengthResMessage	byte	"The length of your string is: ", 0
				
	;message and prompts for String_indexOf_1			
	strTestingIndexOfOne    	byte	"*************************************", 13, 10,
										"*    USING String_indexOf_1       *", 13, 10,
										"*************************************", 13, 10, 0
	strIndexOneStrPrompt    byte	"Enter first string:  ", 0
	strIndexOneCharPrompt   byte	"Enter search  character: ", 0
	strIndexOneIndexResultMessage byte "The first instance index is:    ",0

	;message and prompts for String_indexOf_2
	strTestingIndexOfTwo	byte	"*************************************", 13, 10,
										"*    USING String_indexOf_2       *", 13, 10,
										"*************************************", 13, 10, 0
	strIndexTwoStrPrompt    byte	"Enter first string:  ", 0
	strIndexTwoCharPrompt   byte	"Enter search  character: ", 0
	strIndexTwoIndexPrompt   byte	"Enter the beginning index: ", 0
	strIndexTwoResultMessage   byte	"The first instance index is: ", 0

	;message and prompts for String_indexOf_3
	strTestingIndexOfThree	byte	"*************************************", 13, 10,
										"*    USING String_indexOf_3       *", 13, 10,
										"*************************************", 13, 10, 0
	strIndexThreeStrPrompt    byte	"Enter first string:  ", 0
	strIndexThreeSubstrPrompt   byte	"Enter search  substring: ", 0
	strIndexThreeResultMessage  byte  "The string is at index:  ",0

	;message and prompts for String_toLowerCase
	strTestingStringToLower	byte	"*************************************", 13, 10,
									"*    USING String_toLowerCase     *", 13, 10,
									"*************************************", 13, 10, 0
	strStrToLowerPrompt		byte	"Enter a string:               ", 0
	strStrToLowerMessage	byte	"The lower case string is: ", 0

	;message and prompts for String_toUpperCase
	strTestingStringToUpper	byte	"*************************************", 13, 10,
									"*    USING String_toUpperCase     *", 13, 10,
									"*************************************", 13, 10, 0
	strStrToUpperPrompt		byte	"Enter a string:               ", 0
	strStrToUpperMessage	byte	"The upper case string is: ", 0

	;message and prompts for String_concat
	strTestingStringConcat	byte	"*************************************", 13, 10,
									"*    USING String_concat          *", 13, 10,
									"*************************************", 13, 10, 0
	strStrConcatPrompt1		byte	"Enter the first string:              ", 0
	strStrConcatPrompt2		byte	"Enter the second string:             ", 0
	strStrConcatMessage	    byte	"The concated string is: ", 0

	;message and prompts for String_replace
	strTestingStringReplace	byte	"*************************************", 13, 10,
									"*    USING String_replace         *", 13, 10,
									"*************************************", 13, 10, 0
	strStrReplacePrompt1		byte	"Enter the string:              ", 0
	strStrReplacePrompt2		byte	"Enter the character to replace:             ", 0
	strStrReplacePrompt3		byte	"Enter the new character:             ", 0
	strStrReplaceMessage	    byte	"The changed string is: ", 0

	;message and prompts for String_lastIndexOf_1
	strTestingLastIndexOfOne    	byte	"*************************************", 13, 10,
										"*    USING String_lastIndexOf_1   *", 13, 10,
										"*************************************", 13, 10, 0
	strTestingLastIndexOfOnePrompt1    byte	"Enter first string:  ", 0
	strTestingLastIndexOfOnePrompt2    byte	"Enter search  character: ", 0
	strLastIndexOneEnd				   byte "The index you are looking for is: ",0

	;message and prompts for String_lastIndexOf_2
	strTestingLastIndexOfTwo    	   byte	"*************************************", 13, 10,
										"*    USING String_lastIndexOf_2   *", 13, 10,
										"*************************************", 13, 10, 0
	strTestingLastIndexOfTwoPrompt1    byte	"Enter first string:  ", 0
	strTestingLastIndexOfTwoPrompt2    byte	"Enter search  character: ", 0
	strTestingLastIndexOfTwoPrompt3    byte	"Enter initial index: ", 0
	strStrLastIndexOfOneMessage	       byte	"The last index is: ", 0

	;message and prompts for String_lastIndexOf_3
	strTestingLastIndexOfThree   	byte "*************************************", 13, 10,
										"*    USING String_lastIndexOf_3   *", 13, 10,
										"*************************************", 13, 10, 0
	strTestingLastIndexOfThreePrompt1    byte	"Enter first string:  ", 0
	strTestingLastIndexOfThreePrompt2    byte	"Enter substring: ", 0
	strStrLastIndexOfThreeMessage	     byte	"The last index is: ", 0

	;String_length necessary variables
	strStringLengthString1	byte	D_MAX_STRING_LEN dup (?)	; string1 for String_length
	strStringLengthResult	byte	D_MAX_STRING_LEN dup (?)	; result of String_length

	;String_indexOf_1 necessary variables
	strStringIndexOneString	   byte	D_MAX_STRING_LEN dup (?)	; string1 for String_indexOf_1
	strStringIndexOneCharacter byte D_MAX_STRING_LEN dup (?)	; character to be fund in the string
	strStringIndexOneResult	   byte	D_MAX_STRING_LEN dup (?)	; result of String_indexOf_1

	;String_indexOf_2 necessary variables
	strStringIndexTwoString		byte	D_MAX_STRING_LEN dup (?)	; string1 for String_indexOf_2
	strStringIndexTwoIndex	    byte	D_MAX_STRING_LEN dup (?)	; strting index of String_indexOf_2
	strStringIndexTwoChar	    byte	D_MAX_STRING_LEN dup (?)	; character to be found 
	strStringIndexTwoResult	    byte	D_MAX_STRING_LEN dup (?)	; result index of String_indexOf_1

	;String_indexOf_3 necessary variables
	strStringIndexThreeString		byte	10,13,  "osvaldo",0	; string1 for String_indexOf_3
	strStringIndexThreeSubstring	byte	10,13,  "val",0	; substring for String_indexOf_3
	strStringIndexThreeResultS		byte	D_MAX_STRING_LEN dup (?)	; result index of String_indexOf_3

	;String_toLowerCase necessary variables
	strStringToLowerString	byte	D_MAX_STRING_LEN dup (?)	; string1 for String_ToLowerCase
	strStringToLowerResult	byte	D_MAX_STRING_LEN dup (?)	; result of String_ToLowerCase

	;String_toUpperCase necessary variables
	strStringToUpperString	byte	D_MAX_STRING_LEN dup (?)	; string1 for String_ToUpperCase
	strStringToUpperResult	byte	D_MAX_STRING_LEN dup (?)	; result of String_ToUpperCase

	;String_concat necessary variables
	strStringConcatString1	byte	D_MAX_STRING_LEN dup (?)	; string1 for String_concat
	strStringConcatString2	byte	D_MAX_STRING_LEN dup (?)	; string2 for String_concat
	strStringConcatResult	byte	D_MAX_STRING_LEN dup (?)	; result string of String_concat

	;String_replace necessary variables
	;strStringReplaceString	byte	10,13,  "osvaldo",0	; string that is been past in
	strStringReplaceString	byte	D_MAX_STRING_LEN dup (?)
	
	strStringReplaceOldChar	byte	 'a'	; char to be replaced
	strStringReplaceNewChar	byte	 'o'	; new char that will replace the old
	strStringReplaceResult	byte	D_MAX_STRING_LEN dup (?)	; result of String_replace

	;String_LastIndexOf_1 necessary variables
	strStringLastIndexOneString	   byte	D_MAX_STRING_LEN dup (?)	; string1 for String_LastIndexOf_1
	strStringLastIndexOneCharacter byte D_MAX_STRING_LEN dup (?)	;character to be found in the string
	strStringLastIndexOneResult	   byte	D_MAX_STRING_LEN dup (?)	; result of String_LastIndexOf_1

	;String_LastIndexOf_2 necessary variables
	strStringLastIndexTwoString		byte	D_MAX_STRING_LEN dup (?)	; string1 for String_LastIndexOf_2
	strStringLastIndexTwoIndex	    byte	D_MAX_STRING_LEN dup (?)	; strting index of String_LastIndexOf_2
	strStringLastIndexTwoChar	    byte	D_MAX_STRING_LEN dup (?)	; char to be changed in the string
	strStringLastIndexTwoResult	    byte	D_MAX_STRING_LEN dup (?)	; result of String_LastIndexOf_2

	;String_LastIndexOf_3 necessary variables
	strStringLastIndexThreeString		byte	D_MAX_STRING_LEN dup (?)	; string1 for String_LastIndexOf_3
	strStringLastIndexThreeSubstring	byte	D_MAX_STRING_LEN dup (?)	; substring for String_LastIndexOf_3
	strStringLastIndexThreeResult		byte	D_MAX_STRING_LEN dup (?)	; result of String_LastIndexOf_3

	
	
	;Main menu for the user
	strUserMenuTop   			byte	"***************************************", 13, 10,
										"*           PROGRAM OPTIONS           *", 13, 10,
										"***************************************", 13, 10,0
	strUserMenuOption1   		byte	"* <1> View all Strings                *", 13, 10,0
	strUserMenuOption2   		byte    "* <2> Add String                      *", 13, 10,0
	strUserMenuOption3   		byte	"* <3> Delete String                   *", 13, 10,0
	strUserMenuOption4   		byte	"* <4> Edit String                     *", 13, 10,0
	strUserMenuOption5   		byte	"* <5> String Search                   *", 13, 10,0
	strUserMenuOption6   		byte	"* <6> String Array Memory Consuption  *", 13, 10,0
	strUserMenuOption7   		byte	"* <7> Quit                            *", 13, 10,0
	strUserMenuBottom 			byte	"***************************************", 13, 10, 
										"Enter your choice:  ", 0
										
	strInvalidInput     		byte	"Invalid input. You must input a number between 1 and 7", 13, 10,0	
	strValidInput     			byte	"Valid input mah niBBa", 13, 10,0		
	
	strChoice					byte 11 dup(?)
	dChoice						dword  3d
	
		.code
_start:
	mov EAX, 0									; ensures first instruction can be executed in Ollydbg

	INVOKE putstring, ADDR strAssignmentHeader	; outputs assignment header
	
	;INVOKE putstring, ADDR strCRLF
	
beginning:

	INVOKE putstring, ADDR crlf
	INVOKE putstring, ADDR strUserMenuTop
	INVOKE putstring, ADDR strUserMenuOption1
	INVOKE putstring, ADDR strUserMenuOption2
	INVOKE putstring, ADDR strUserMenuOption3
	INVOKE putstring, ADDR strUserMenuOption4
	INVOKE putstring, ADDR strUserMenuOption5
	INVOKE putstring, ADDR strUserMenuOption6
	INVOKE putstring, ADDR strUserMenuOption7
	INVOKE putstring, ADDR strUserMenuBottom
	
	;INVOKE getstring, ADDR strChoice, 32
	;INVOKE ascint32,  ADDR strChoice
	;mov dChoice, eax
	
	push dChoice
	call dwordErrorCheck
	add esp, 4
	
	
	cmp eax, -1
	JE  invalidMessage

	JMP issavalid

	;more stuff to come in this section


invalidMessage:
	INVOKE putstring, ADDR crlf
	INVOKE putstring, ADDR strInvalidInput
	JMP beginning
	
issavalid:

	INVOKE putstring, ADDR crlf
	INVOKE putstring, ADDR strValidInput
	JMP beginning
	
	
	
;**********************END OF TESTING**********************
	
	INVOKE ExitProcess, 0						; terminates program normally	
	
	PUBLIC _start

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

dwordErrorCheck endp
	
	
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
