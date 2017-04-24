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
									"Name:       Arang Christopher Montazer & Osvaldo Moreno Ornelas",		
									13, 10, 9, 
									"Program:    MASM3.asm", 
									13, 10, 9, 
									"Class:      CS3B", 
									13, 10, 9, 
									"Date:       March 28, 2017", 
									13, 10, 13, 10, 0
		
		
	strCRLF					byte	13, 10, 0
	strBackspace			byte	8, 32, 8, 0

	D_MAX_STRING_LEN = 32

	;message and prompts for String_length
	strTestingStringLength	byte	"*************************************", 13, 10,
									"*       TESTING String_length       *", 13, 10,
									"*************************************", 13, 10, 0
	strStrLengthPrompt		byte	"Enter a string:               ", 0
	strStrLengthResMessage	byte	"The length of your string is: ", 0
				
	;message and prompts for String_indexOf_1			
	strTestingIndexOfOne    	byte	"*************************************", 13, 10,
										"*    TESTING String_indexOf_1       *", 13, 10,
										"*************************************", 13, 10, 0
	strIndexOneStrPrompt    byte	"Enter first string:  ", 0
	strIndexOneCharPrompt   byte	"Enter search  character: ", 0
	strIndexOneIndexResultMessage byte "The first instance index is:    ",0

	;message and prompts for String_indexOf_2
	strTestingIndexOfTwo	byte	"*************************************", 13, 10,
										"*    TESTING String_indexOf_2       *", 13, 10,
										"*************************************", 13, 10, 0
	strIndexTwoStrPrompt    byte	"Enter first string:  ", 0
	strIndexTwoCharPrompt   byte	"Enter search  character: ", 0
	strIndexTwoIndexPrompt   byte	"Enter the beginning index: ", 0
	strIndexTwoResultMessage   byte	"The first instance index is: ", 0

	;message and prompts for String_indexOf_3
	strTestingIndexOfThree	byte	"*************************************", 13, 10,
										"*    TESTING String_indexOf_3       *", 13, 10,
										"*************************************", 13, 10, 0
	strIndexThreeStrPrompt    byte	"Enter first string:  ", 0
	strIndexThreeSubstrPrompt   byte	"Enter search  substring: ", 0
	strIndexThreeResultMessage  byte  "The string is at index:  ",0

	;message and prompts for String_toLowerCase
	strTestingStringToLower	byte	"*************************************", 13, 10,
									"*    TESTING String_toLowerCase     *", 13, 10,
									"*************************************", 13, 10, 0
	strStrToLowerPrompt		byte	"Enter a string:               ", 0
	strStrToLowerMessage	byte	"The lower case string is: ", 0

	;message and prompts for String_toUpperCase
	strTestingStringToUpper	byte	"*************************************", 13, 10,
									"*    TESTING String_toUpperCase     *", 13, 10,
									"*************************************", 13, 10, 0
	strStrToUpperPrompt		byte	"Enter a string:               ", 0
	strStrToUpperMessage	byte	"The upper case string is: ", 0

	;message and prompts for String_concat
	strTestingStringConcat	byte	"*************************************", 13, 10,
									"*    TESTING String_concat          *", 13, 10,
									"*************************************", 13, 10, 0
	strStrConcatPrompt1		byte	"Enter the first string:              ", 0
	strStrConcatPrompt2		byte	"Enter the second string:             ", 0
	strStrConcatMessage	    byte	"The concated string is: ", 0

	;message and prompts for String_replace
	strTestingStringReplace	byte	"*************************************", 13, 10,
									"*    TESTING String_replace         *", 13, 10,
									"*************************************", 13, 10, 0
	strStrReplacePrompt1		byte	"Enter the string:              ", 0
	strStrReplacePrompt2		byte	"Enter the character to replace:             ", 0
	strStrReplacePrompt3		byte	"Enter the new character:             ", 0
	strStrReplaceMessage	    byte	"The changed string is: ", 0

	;message and prompts for String_lastIndexOf_1
	strTestingLastIndexOfOne    	byte	"*************************************", 13, 10,
										"*    TESTING String_lastIndexOf_1   *", 13, 10,
										"*************************************", 13, 10, 0
	strTestingLastIndexOfOnePrompt1    byte	"Enter first string:  ", 0
	strTestingLastIndexOfOnePrompt2    byte	"Enter search  character: ", 0
	strLastIndexOneEnd				   byte "The index you are looking for is: ",0

	;message and prompts for String_lastIndexOf_2
	strTestingLastIndexOfTwo    	   byte	"*************************************", 13, 10,
										"*    TESTING String_lastIndexOf_2   *", 13, 10,
										"*************************************", 13, 10, 0
	strTestingLastIndexOfTwoPrompt1    byte	"Enter first string:  ", 0
	strTestingLastIndexOfTwoPrompt2    byte	"Enter search  character: ", 0
	strTestingLastIndexOfTwoPrompt3    byte	"Enter initial index: ", 0
	strStrLastIndexOfOneMessage	       byte	"The last index is: ", 0

	;message and prompts for String_lastIndexOf_3
	strTestingLastIndexOfThree   	byte "*************************************", 13, 10,
										"*    TESTING String_lastIndexOf_3   *", 13, 10,
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

		.code
_start:
	mov EAX, 0									; ensures first instruction can be executed in Ollydbg

	INVOKE putstring, ADDR strAssignmentHeader	; outputs assignment header
	
	INVOKE putstring, ADDR strCRLF

	;++++++++++++++++++++++
;**********************************************************
;+String_length(string1:String):int  
;It returns the lenght of the string
;**********************************************************	

	; INVOKE putstring, ADDR strTestingStringLength	; outputs strTestingStringLength
	; INVOKE putstring, ADDR strStrLengthPrompt		; prompts for string input
	; INVOKE getstring, ADDR strStringLengthString1,	; gets user input for strStringLengthString1
					  ; D_MAX_STRING_LEN
	
	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
	
	; push OFFSET strStringLengthString1				; pushes "string1" onto Stack
	; call String_length								; calls String_length with strStringLengthString1
	; add  ESP, 4										; re-adjusts ESP after call 
	
	; INVOKE intasc32, ADDR strStringLengthResult,	; converts int result of String_length to string
					 ; EAX
	
	; INVOKE putstring, ADDR strStrLengthResMessage	; outputs message before result
	; INVOKE putstring, ADDR strStringLengthResult	; outputs result of String_length
	
	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
	

	;**********************************************************
	;+String_toUpperCase(string1:String):String   
	;It converts the string to upper case string
	;**********************************************************
	; INVOKE putstring, ADDR strStringToUpperString		;outputs the header for the method test
	; INVOKE putstring, ADDR strStrToUpperPrompt			;prompts for the string
	; INVOKE getstring, ADDR strStringToUpperString, D_MAX_STRING_LEN	;gets the string from user

	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed

	; push OFFSET strStringToUpperString				;push the string into the stack
	; call String_toUpperCase							;call the method

	; add esp, 4										;add 4 to esp (4 bytes for addressing)

	; INVOKE putstring, ADDR strStrToUpperMessage     ;output message for result
	; INVOKE putstring,  eax							;output the uppercase string

	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
		

	;**********************************************************
	;+String_toLowerCase(string1:String):String  
	;It converts the string to lower case string
	;**********************************************************
	; INVOKE putstring, ADDR strTestingStringToUpper  ;output header
	; INVOKE putstring, ADDR strStrToLowerPrompt		;output the prompt

	; INVOKE getstring, ADDR strStringToLowerString, D_MAX_STRING_LEN	;get the string
	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed

	; push OFFSET strStringToLowerString				;push string into the stack
	; call String_toLowerCase							;call method
	; add esp, 4										;add 4 to the esp

	; INVOKE putstring, ADDR strStrToLowerMessage		;output resuult message
	; INVOKE putstring,  eax							;output message

	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
		

	;**********************************************************
	;+String_indexOf_1(string1:String,ch:char):int 
	;Returns the index of first occurrence of the specified 
	;character ch in the string.
	;**********************************************************
	; INVOKE putstring, ADDR strTestingIndexOfOne		;output the header
	; INVOKE putstring, ADDR strIndexOneStrPrompt		;output input prompt

	; INVOKE getstring, ADDR strStringIndexOneString, D_MAX_STRING_LEN	;get string from user
	; INVOKE putstring, ADDR strCRLF					;skip a line

	; INVOKE putstring, ADDR strIndexOneCharPrompt	;prompt for char

	; INVOKE getch									;get char from the user

	; movsx ax, al									;store in the ax and expand register
	; push ax											;puhs char into the stack
	; push OFFSET strStringIndexOneString				;push string into the stack

	; call String_indexOf_1							;call the method

	; add esp, 6										;add 6 to the esp

	; INVOKE putstring, ADDR strCRLF					; outputs a carriage-return and line-feed
		
	; INVOKE putstring, ADDR strIndexOneIndexResultMessage ;output message
	; INVOKE intasc32, ADDR strStringIndexOneResult, eax	 ;convert to ascii
	; INVOKE putstring, ADDR strStringIndexOneResult		 ;output ascii value
		
	; ;make newlines (endl)
	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strCRLF	

	;****************************************************************
	;+String_indexOf_2(string1:String,ch:char,fromIndex:int):int    
	;Same as indexOf method however it starts searching in the 
	;string from the specified fromIndex.
	;****************************************************************
	; INVOKE putstring, ADDR strTestingIndexOfTwo			;header
	; INVOKE putstring, ADDR strIndexTwoStrPrompt			;prompt
	; INVOKE getstring, ADDR strStringIndexTwoString, D_MAX_STRING_LEN ;get string from user

	; INVOKE putstring, ADDR strCRLF						;endl
	; INVOKE putstring, ADDR strIndexTwoCharPrompt		;prompt for char to search

	; INVOKE getch										;get char from the user
	; INVOKE putch, al

	; INVOKE putstring, ADDR strCRLF
	; INVOKE putstring, ADDR strIndexTwoIndexPrompt		;starting index prompt
	; INVOKE getstring, ADDR strStringIndexTwoIndex, D_MAX_STRING_LEN ;get index from the user

	; ;push and call
	; INVOKE ascint32, ADDR strStringIndexTwoIndex		;get int of the inputed num (was ascii)

	; push eax											;push it into the stack

	; MOV  al, strStringIndexTwoChar						;mov index and push it
	; movsx ax, al

	; push ax
	; push OFFSET strStringIndexTwoString					;push string into the stack

	; call String_indexOf_2								;call procedure

	; add esp, 10											;add 10 to the esp

	; INVOKE putstring, ADDR strCRLF						;newline
	; INVOKE putstring, ADDR strIndexTwoResultMessage		;output message
	; INVOKE intasc32, ADDR strStringIndexTwoResult, eax	;convert the index result

	; INVOKE putstring, ADDR strStringIndexTwoResult		;output the index result

	; ;newlines
	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strCRLF		
	;*******************************************************
	;+String_IndexOf_3(string1:String,str:String):int  
	;Returns the index of last occurrence of string str.
	;*******************************************************

	; INVOKE putstring, ADDR strTestingIndexOfThree	;output header
	; INVOKE putstring, ADDR strIndexThreeStrPrompt	;output prompt

	; INVOKE getstring, ADDR strStringIndexThreeString, D_MAX_STRING_LEN ;get string

	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strIndexThreeSubstrPrompt
	; INVOKE getstring, ADDR strStringIndexThreeSubstring, D_MAX_STRING_LEN ;get substring

	; ;push data into the stack
	; push OFFSET strStringIndexThreeString
	; push OFFSET strStringIndexThreeSubstring

	; call String_IndexOf_3								;call procedure

	; add esp, 8											;add 8 to esp

	; INVOKE putstring, ADDR strCRLF						;endl
	; INVOKE putstring, ADDR strIndexThreeResultMessage	;output message
	; INVOKE intasc32, ADDR strStringIndexThreeResultS, eax ;convert to ascii

	; INVOKE putstring, ADDR strStringIndexThreeResultS	;output index
		
	; ;endl
	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strCRLF	

	;*******************************************************
	;+String_concat(string1:String,str:String):String  
	;*******************************************************	
	; INVOKE putstring, ADDR strTestingStringConcat		;output header
	; INVOKE putstring, ADDR strStrConcatPrompt1			;first prompt

	; INVOKE getstring, ADDR strStringConcatString1, D_MAX_STRING_LEN ;get string one

	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strStrConcatPrompt2			;second prompt
	; INVOKE getstring, ADDR strStringConcatString2, D_MAX_STRING_LEN	;get string 2

	; ;push string into the stack
	; push OFFSET strStringConcatString1
	; push OFFSET strStringConcatString2

	; ;call procedure
	; call String_concat
	; add esp, 8												;add 8 to the esp

	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strStrConcatMessage				;message 
	; INVOKE putstring, eax									;cocatenated string

	; ;endl
	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strCRLF
		
	;*********************************************************************************
	;+String_replace(string1:String,oldChar:char,newChar:char):String  
	;It returns the new updated string after changing all the occurrences of oldChar 
	;with the newChar.
	;
	;*********************************************************************************


	INVOKE putstring, ADDR strTestingStringReplace		;output header
	INVOKE putstring, ADDR strStrReplacePrompt1			;main string prompt
	INVOKE getstring, ADDR strStringReplaceString, D_MAX_STRING_LEN	;get string
		
	INVOKE putstring, ADDR strCRLF	;endl
	INVOKE	putstring, ADDR strStrReplacePrompt2		;char prompt
	INVOKE getch										;get char
	
	INVOKE putch, al									;output the char to the window

	;mov al, strStringReplaceOldChar
	movsx ax, al										;store and sign extend register
		
	INVOKE putstring, ADDR strCRLF						;endl	
	INVOKE	putstring, ADDR strStrReplacePrompt3		;replace char prompt
	INVOKE getch										;get second char
	INVOKE putch, al									;output second char to the window
	
	mov bl, al
	movsx bx, bl										;store and sign extend register
	

	;push data into the stack
	
	push ax
	push bx

	push OFFSET strStringReplaceString

	;call the method
	call String_replace

	add esp, 8											;add 8 to esp

	INVOKE putstring, ADDR strCRLF	
	INVOKE	putstring, ADDR strStrReplaceMessage		;replaced message
	INVOKE putstring, eax								;output new string
	
	;endl
	INVOKE putstring, ADDR strCRLF	
	INVOKE putstring, ADDR strCRLF	
	INVOKE putstring, ADDR strCRLF
	
	
	
;**************************************************
;The following wok the same as Index of 1,2,3
;**************************************************

;*************************************************
 ;+String_lastIndexOf_1(string1:String, ch:char):int   
 ;It returns the last occurrence of the character 
 ;ch in the string.
 ;*************************************************
	; INVOKE putstring, ADDR strTestingLastIndexOfOne						
	; INVOKE putstring, ADDR strTestingLastIndexOfOnePrompt1
	; INVOKE getstring, ADDR strStringLastIndexOneString, D_MAX_STRING_LEN
	
	; INVOKE putstring, ADDR strCRLF
	; INVOKE putstring, ADDR strTestingLastIndexOfOnePrompt2
	; INVOKE getche
	; ;INVOKE putch, al
	
	
	; movsx ax, al
	
	; push ax
	; push OFFSET strStringLastIndexOneString
	
	; call String_lastIndexOf_1
	
	; add esp, 6
	
	; INVOKE putstring, ADDR strCRLF	

	; INVOKE putstring, ADDR strLastIndexOneEnd
	; INVOKE intasc32, ADDR strStringLastIndexOneResult,eax
	; INVOKE putstring, ADDR strStringLastIndexOneResult
	
	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strCRLF	
	; INVOKE putstring, ADDR strCRLF
	
	
; ;*******************************************************************
; ;+String_lastIndexOf_2(string1:String,ch:char,fromIndex:int):int  
; ;Same as lastIndexOf_1 method, but it starts search from fromIndex.
; ;
; ;*******************************************************************
	; INVOKE putstring, ADDR strTestingLastIndexOfTwo
	; INVOKE putstring, ADDR strTestingLastIndexOfTwoPrompt1
	
	; INVOKE getstring, ADDR strStringLastIndexTwoString, D_MAX_STRING_LEN
	
	
	; INVOKE putstring, ADDR strCRLF
	; INVOKE putstring, ADDR strTestingLastIndexOfTwoPrompt2
	
	
	; INVOKE getstring, ADDR strStringIndexTwoIndex, D_MAX_STRING_LEN

	; ;push and call
	; INVOKE ascint32, ADDR strStringIndexTwoIndex

	; push eax
	
	; INVOKE putstring, ADDR strCRLF
	; INVOKE putstring, ADDR strTestingLastIndexOfTwoPrompt3
	; INVOKE putstring, ADDR strCRLF
	
	; INVOKE putstring, ADDR strStrLastIndexOfOneMessage
	
	
	; INVOKE putstring, ADDR strCRLF
	; INVOKE putstring, ADDR strCRLF
	; INVOKE putstring, ADDR strCRLF


; ;*********************************************************
; ;+String_lastIndexOf_3(string1:String,str:String):int  
; ;Returns the index of last occurrence of string str.
; ;*********************************************************

	INVOKE putstring, ADDR strTestingLastIndexOfThree
	;INVOKE putstring, ADDR strTestingLastIndexOfThreePrompt1
	;INVOKE getstring, ADDR strStringLastIndexThreeString, D_MAX_STRING_LEN      ;get the first string
	
	;INVOKE putstring, ADDR strCRLF
	;INVOKE putstring, ADDR strTestingLastIndexOfThreePrompt2   ;prompt for the substring
	;INVOKE getstring, ADDR strStringLastIndexThreeSubstring, D_MAX_STRING_LEN	   ;get the substring from the user
	
	
	push OFFSET strStringLastIndexThreeString
	push OFFSET strStringLastIndexThreeSubstring
	
	
	call String_lastIndexOf_3
	
	add esp, 8
	
	INVOKE putstring, ADDR strCRLF
	INVOKE putstring, ADDR strStrLastIndexOfThreeMessage
	
	INVOKE intasc32, ADDR strStringLastIndexThreeResult, eax
	INVOKE putstring, ADDR  strStringLastIndexThreeResult
		
	
;**********************END OF TESTING**********************
	
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
