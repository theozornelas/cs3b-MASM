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
		
		;include macros and external libraries
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

	D_MAX_STRING_LEN = 32		;max lenght for a string

	
	strChoice					byte 11 dup(?)
	dChoice						dword  ?
	
	bWordArray					byte 1280 dup(?)				;array of contents
	
	strAddString				byte 128 dup(?)
	strDeleteString				byte 128 dup(?)
	strSearchString				byte 128 dup(?)
	strEditString				byte 128 dup(?)
	
	strMemoryConsumed			byte 3000 dup(?)
	
		.code
_start:
	mov EAX, 0									; ensures first instruction can be executed in Ollydbg

	;Here we change the console color
	mov AX, green								;add color to the eax
	push AX										;push the register AX
	call setTextColor							;call the propcedure from the external libraries
	add esp, 2 									;add 2 bytes to the esp 
	
	
	call Clrscr
	call output_header							;ouput the class header
	JMP beginning
	
clearScreen:
		call Clrscr								;clear the screen so only the current interface can be seen

	;the beginning of the user option interface
beginning:

	
	call output_menu							;output the user menu
	
	INVOKE getstring, ADDR strChoice, 32		;get the user's choice from the menu
	INVOKE ascint32,  ADDR strChoice			;conver to in from ascii
	mov dChoice, eax
	
	push dChoice
	call dwordErrorCheck						;check if the user inputted a valid option
	add esp, 4
	
	cmp eax, -1									;if the returned value is -1, then the input was invalid 
	JE  invalidMessage							;so we jump to invalidMessage label

	cmp eax, 7									;if the input is 7, we terminate the prgram
	JE endprogram
	
	cmp eax, 1									;if the input is one, then we view all the strings inside the array
	JE  viewAll
	
	cmp eax, 2									;if the input is 2, then we go to the label where we promped the user for a string to add
	JE  addString
	
	cmp eax, 3									;if the input is 3, then we go to the label where we promped the user for a string to delete
	JE deleteString
	
	cmp eax, 4									;if the input is 4, then we go to the label where we promped the user for a string to edit
	JE editString
	
	cmp eax, 5									;if the input is 5, then we go to the label where we promped the user for a string to search
	JE stringSearch
	
	cmp eax, 6									;if the input is 6, then we go to the label where we show the user the current memory consumption
	JE memoryConsuuption

;*****************************************************************
;here are the labels to prompt the user and display the desired
;operations from the menu
;*****************************************************************	
viewAll:										;view all the string in the array
	
	call Crlf
	mWrite "Displaying all Strings: "
	call Crlf
	push offset bWordArray						;push the array into the procedure
	call Display_Array							;call the disply array procedure
	add esp, 4									;add 4 to the esp
	
	call Crlf									;clear the screen
	call WaitMsg								;wait for the user to hit a key
	JMP clearScreen								;go to clear screen label
	
;here we add a string into the array
addString:
	
	call Crlf
	mWrite "Enter a new String: "				;prompt the user
	
	INVOKE getstring, ADDR strAddString, 128	;getstring
	
	push offset strAddString					;push word to add
	call Add_String								;call the add procedure
	add esp, 4									;add 4 to the esp
	
	;clear screen, wait for input, and jump back to the beginning to clear the screen
	call Crlf
	call WaitMsg
	JMP clearScreen
	
	;in this label a string will be deleted
deleteString:
	
	call Crlf
	mWrite "What string you want to delete? "	;prompt for the string to delete
	INVOKE getstring, ADDR strDeleteString, 128
	call Crlf
	
	call WaitMsg
	JMP clearScreen
	
	;in this label we edit a string inside the string
editString:
	
	call Crlf
	mWrite "What string you want to edit? "		;prompt user for what string index to modify
	INVOKE getstring, ADDR strEditString, 128
	
	;clear screen, wait for input, and jump back to the beginning to clear the screen
	call Crlf
	call WaitMsg
	JMP clearScreen
	
	;in this label we find all the instances of a string within the array
stringSearch:
	
	call Crlf										
	mWrite "What string you want to search? "	;prompt the user for the string to search
	INVOKE getstring, ADDR strSearchString, 128
	
	;clear screen, wait for input, and jump back to the beginning to clear the screen
	call Crlf
	call WaitMsg
	JMP clearScreen
	
	;In this label we show the user the amount of memory used (spaces used out of 1280)
memoryConsuuption:
	
	call Crlf											;output the memory consumption to the user
	mWrite "The memory consumption is currently: "
	
	
	;call Check_Memory									;call the calculating function
	
	;INVOKE intasc32, addr strMemoryConsumed, eax		;put result from eax into a string
	;INVOKE putstring, addr strMemoryConsumed			;output the string
	
	;clear screen, wait for input, and jump back to the beginning to clear the screen
	call Crlf
	call WaitMsg
	JMP clearScreen


	;if there is a invalid input let the user know the actual boundaries
invalidMessage:

	call Crlf
	mWrite "Invalid Input. Please input a number between 1 and 7"
	
	call Crlf
	call WaitMsg
	JMP clearScreen
	
	;if it is a valid input
issavalid:

	call Crlf
	mWrite "Valid Data Inputted"

	call Crlf
	call WaitMsg
	JMP clearScreen
	

;end the program	
endprogram:
	call Crlf
	mWrite "Thank You, have an average day!"
	call Crlf
	call WaitMsg
	
	;reset the command window color
	mov AX, lightGray
	push AX
	call setTextColor
	add esp, 2 
	
;**********************END OF MAIN**********************

	
	INVOKE ExitProcess, 0						; terminates program normally	
	
	PUBLIC _start

;**********************************************************
;The following procedures are used to do the required
;operations for this assignment
;**********************************************************
	
;**********************************************************
;Check for an empty spot as in a switch statement
;**********************************************************
Check_Spot Proc Near32
	push ebp		
	mov ebp, esp
	
	push ebx
	push ecx
	push esi
	
	mov esi, 0
	
	mov ebx, offset bWordArray	;load array into the ebx
	mov ecx, [esp+8]			;number
	
	;if any of the start indexes for the strings is empty, then
	;break out of the procedure
	
	.IF ebx == 1
		cmp byte ptr[ecx[ebx]], 0
		JE emptySpot
	.ELSEIF ebx == 2
		cmp byte ptr[ecx[128]], 0
		JE emptySpot
	.ELSEIF ebx == 3
		cmp byte ptr[ecx[256]], 0
		JE emptySpot
	.ELSEIF ebx == 4
		cmp byte ptr[ecx[384]], 0
		JE emptySpot
	.ELSEIF ebx == 5
		cmp byte ptr[ecx[512]], 0
		JE emptySpot
	.ELSEIF ebx == 6
		cmp byte ptr[ecx[640]], 0
		JE emptySpot
	.ELSEIF ebx == 7
		cmp byte ptr[ecx[768]], 0
		JE emptySpot
	.ELSEIF ebx == 8
		cmp byte ptr[ecx[896]], 0
		JE emptySpot
	.ELSEIF ebx == 9
		cmp byte ptr[ecx[1024]], 0
		JE emptySpot
	.ELSEIF ebx == 10
		cmp byte ptr[ecx[1152]], 0
		JE emptySpot
	.ELSE
		JMP notEmpty
		
	.ENDIF

	;the spot is empty so return true (1)
	emptySpot:
		mov esi, 1
		JMP endProcedure
		
	;the spot is not empty so return false (choosed -1 because yes)
	notEmpty:
		mov esi, -1
		
	;do the end operations
	endProcedure:
	
		;return if the spot is open
		mov eax, esi
	
		;pop registers from the stack
		pop esi
		pop ecx
		pop ebx
		pop ebp
	
		RET
	
Check_Spot endp
	
;**********************************************************
;This procedure is to error check the user option
;**********************************************************
Display_Array PROC Near32
	push ebp		
	mov ebp, esp

	push ebx				;stores the array
	push esi 				;counter
	push edi				;used to loop through the section
	push ecx				;stores the current max	
	
	mov ebx, [ebp + 8]		;points to the array
	mov esi, 0				;initialize the iterator to zero
	mov edi, 0				;set the sector iterator to zero
	
	;loop that iterates the array
	loopBack:
	
		;if is not the end of the array
		;.IF esi < 10
		.IF edi < 1280
			mWrite "String #: "
			
			;converst the index into a char for output
			mov eax, esi
			add eax, 30h
			
			INVOKE putch, al
			
			inc esi								;increase the index
			
			;display character label
			displayChar:
			
				.IF byte ptr[ebx + edi] == 0	;if the spot is empty
					mWrite "  <Empty Spot>"		;write empty spot
					call Crlf					;newline
					add edi, 128				;add 128 (go forward 128)
					JMP loopBack				;loop in the next sector
				
				.ENDIF
			
			mWrite "  "
			INVOKE putstring, [ebx +edi]	    ;else output the contents
			call Crlf	
			;inc esi								;increment the index
			add edi, 128						;advance 128 characters

			JMP loopBack						;go back to the loop
				
			call Crlf							;newline
		.ELSE
			JMP endProc							;if is the end of the array, escape
		.ENDIF
	JMP loopBack

endProc:
	pop ecx
	pop edi
	pop esi
	pop ebx
	pop ebp

	RET

Display_Array endp	

;**********************************************************
;This procedure is to add a string to the array
;**********************************************************	
Add_String PROC Near32

	push ebp		
	mov ebp, esp

	push ebx				;reserve the ebx register
	push ecx				;reserve the ecx register
	push edx				;reserve the edx register
	push esi 				;reserve the esi register
	
	mov ebx, offset bWordArray	;points to the first thing in the stack, in this case is the array
	mov ecx, [ebp + 8]		    ;points to the second thing in the stack, in this case is the string to add
	mov esi, 0				    ;initialize esi to zero
	
	.IF byte ptr[ebx+esi] == 0				;first spot is empty
		
		;then add first index
		mov [ebx + esi], ecx				;put the contents in thae first spot
		JMP endProcedure					;leave the procedure
	.ELSE
		JMP findSpot						;if the first is not empty find the first available spot
		
	.ENDIF
	
	
	;find the correct spot to add the string into
findSpot:
	push ebx
	call First_Empty
	add esp, 4
	
	mov esi, eax
	
	;this moves the content?
	mov[ebx + esi], ecx
	
	
endProcedure:

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop ebp
	
	RET
	
Add_String endp

;**********************************************************
;This procedure is to delete a string to the array
;**********************************************************	
Delete_String PROC Near32

	push ebp		
	mov ebp, esp

	; push ebx				;reserve the ebx register		
	; push esi
	
	; mov ebx, [esp + 8]      ;number to delete
	
	; mov esi, [ebx] * 128 		;valid?
	
	; deleteLoop:
		; mov ebx[esi], 0
		
		; .IF esi < 128 * [ebx + 1]
			; inc esi
		; .ELSE
		    ; JE endProcedure
		
		; .ENDIF
		
		
	; JMP deleteLoop
	
	; endProcedure:
		; pop esi
		; pop ebx
		; pop ebp
		
		
	RET
	
Delete_String endp

;**********************************************************
;This procedure is to check the size of the array
;**********************************************************	
Check_Memory Proc Near32
	push ebp					
	mov ebp, esp
	
	push ebx						;preserve the ebx register
	push esi						;preserve the esi register
	push edi						;preserve the edi register
	
	mov ebx, offset bWordArray		;put the array into the resgister
	mov esi, 0						;initialize byte iterator to zero
	mov edi, 0						;initialize used space counter to zero
	
	;this lopp iterates through the whole array
loopStart:

	;if the counter reaches 1280(the end of the array)
	cmp esi,1200
	JE endProcedure

	.IF byte ptr[ebx+esi] == 0		;if the content at that byte is null (0)
		inc esi						;increase the esi to go forward in the array
		jmp loopStart				;loop back
	.ELSE							;else the spot is not empty
		inc edi						;increment the amount of non empty spots
		inc esi						;increment the index
		jmp loopStart				;loop back
	.ENDIF							;end block
	
	;end the procedure
endProcedure:

	mov eax, edi					;move the amount of used spots in the eax
	
	;pop registers from the stack
	pop edi
	pop esi
	pop ebx

	RET 
Check_Memory endp

;**********************************************************
;Modify a string in the array
;**********************************************************
String_Edit Proc Near32
	push ebp		
	mov  ebp, esp
	
	; push ebx
	; push ecx
	; push edx				;current position
	; push esi
	
	; mov ebx, [esp+8]		;string number
	; mov ecx, [esp+8]		;string to replace with
	; mov esi ,0
	
	; mov edx, ebx * 128
	
	; .IF [ebx + edx] != 0
		; ;replace
		
		; loopBack:
			; mov [ebx + edx], [ecx + esi]
			; inc edi
			; inc esi
			; ;if the esi is the same as string size, go to clear everything else
		; JMP loopBack
		; ;call string replace
		; JMP endProcedure
		
	; .ELSE
		; JMP empty
	; .ENDIF
	
	
	; clearAll:
		; ;go to current address and clear until (ebx * 128) + 128
		
		; mov [ebx + edx],0
		; cmp edi, ebx+1 * 128
		; JE endProcedure
		
		; JMP clearAll
	
	; empty:
		; mWrite "The spot is empty, cannot replace the string"
		
	; endProcedure:
	
	 ; pop esi
	 ; pop edx
	 ; pop ecx
	 ; pop ebx
	 ; pop ebp
	
	RET
	
String_Edit endp

;**********************************************************
;This procedure replaces a string
;**********************************************************

;**********************************************************
;Get the number of instances of a word (array, word)
;**********************************************************
String_Search Proc Near32
	push ebp
	mov ebp, esp
	
	push ebx 
	push ecx
	push esi
	push edi
	;make counter for times found
	
	mov ebx, [ebp + 8]    ;array
	mov ecx, [ebp + 12]	  ;word
	
	mov esi, 0
	mov edi, 0
	
 search:
 
	cmp ebx, 0			;if empty
	JE  emptyArray
	
	cmp byte ptr[ebx + esi], 0
	JE search
	;inc esi
	
	; cmp esi, 1280
	; JE emptyArray
	
lookForward:

	mov esi,0		;number of times found
	
	;do a character match algorithm
	;if all the characters match, add 1 to the esi, and keep looking
	

	
 emptyArray:
	mov esi, -1 

endProcedure:
	mov eax, esi
	
	pop edi
	pop esi
	pop ebx
	pop ebp

	RET
	
String_Search endp

;**********************************************************
;Get the first empty spot  (array) (returns an address)
;**********************************************************
First_Empty Proc Near32
	push ebp
	mov  ebp, esp
	push ebx
	push esi
	
	mov ebx, [esp + 8]
	mov esi, 0
	
	search:
	.IF byte ptr[ebx+esi] != 0 && esi <1280
		add esi, 128
		JMP search
	.ELSE
		JMP endProcedure
		
	.ENDIF
	
notFound:
	mov esi, -1
	
	
endProcedure:
	mov eax, esi
	
	pop esi
	pop ebx
	pop ebp
	
	RET
	
First_Empty endp
	
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
	mWrite "Date:       5/10/17" 
	call Crlf	

	RET
	
output_header endp

	END
