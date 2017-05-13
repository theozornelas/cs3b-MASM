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
	
	bWordArray					byte 1280 dup(?)					;array of contents
	dWordArray					dword 128 dup(10)					;array of 10 dwords
	
	strAddString				byte 128 dup(?)						;stores the striing to be added
	strDeleteString				byte 128 dup(?)						;stores the string number to be deleted
	strSearchString				byte 128 dup(?)						;stores the string to be searched
	strEditString				byte 128 dup(?)						;stores the number of the string to be edited
	
	strMemoryConsumed			byte 3000 dup(?)					;stores the amount of memory consumed
	
	dIndexChoice				dword 	?				;string to  delete
	
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
	JE memoryConsuption

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
	
	INVOKE getstring, ADDR strAddString, 127	;getstring
	
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
	
	INVOKE ascint32,  ADDR strDeleteString
	mov dIndexChoice, eax
	
	push dIndexChoice
	call Delete_String
	add esp, 4
	
	call Crlf
	
	call WaitMsg
	JMP clearScreen
	
	;in this label we edit a string inside the string
editString:
	
	call Crlf
	mWrite "What string you want to edit? "		;prompt user for what string index to modify
	INVOKE getstring, ADDR strDeleteString, 128
	INVOKE ascint32,  ADDR strDeleteString
	mov dIndexChoice, eax
	
	call Crlf
	mWrite "What string do you want to replace it with? "
	INVOKE getstring, ADDR strAddString, 128
	
	;call the edit procedure
	push dIndexChoice
	push offset strAddString
	
	call String_Edit
	 
	add esp, 8
	
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
memoryConsuption:
	
	call Crlf											;output the memory consumption to the user
	mWrite "The memory consumption is currently: "
	
	
	call Check_Memory									;call the calculating function
	
	INVOKE intasc32, addr strMemoryConsumed, eax		;put result from eax into a string
	INVOKE putstring, addr strMemoryConsumed			;output the string
	
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
;Find the address of the first index
;**********************************************************
Find_Address Proc Near32
	push ebp		
	mov ebp, esp
	push ebx
	
	mov ebx, offset bWordArray


Find_Address endp	
	
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
	
	mov ecx, offset bWordArray	;load array into the ebx
	;mov ecx, [esp+8]			;number
	
	;if any of the start indexes for the strings is empty, then
	;break out of the procedure
	
	.IF byte ptr[ecx[0]] == 0
		mov esi, 0
		JMP endProcedure
		
	.ELSEIF  byte ptr[ecx[128]] == 0
		mov esi, 128
		JMP endProcedure
		
	.ELSEIF byte ptr[ecx[256]] == 0
		mov esi, 256
		JMP endProcedure
		
	.ELSEIF byte ptr[ecx[384]] == 0
		mov esi, 384
		JE endProcedure
		
	.ELSEIF byte ptr[ecx[512]] == 0
		mov esi, 512
		JE endProcedure
	
	.ELSEIF byte ptr[ecx[640]] == 0
		mov esi, 640
		JE endProcedure
		
	.ELSEIF byte ptr[ecx[768]] == 0
		mov esi, 768
		JE endProcedure
		
	.ELSEIF byte ptr[ecx[896]] == 0
		mov esi, 896
		JE endProcedure
		
	.ELSEIF  byte ptr[ecx[1024]] == 0
		mov esi, 1024
		JE endProcedure
		
	.ELSEIF  byte ptr[ecx[1152]] == 0
		mov esi, 1152
		JE endProcedure
	
	.ELSE
		JMP notEmpty
		
	.ENDIF

		
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
	
	mov ebx, offset bWordArray		;points to the array
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
			
			.IF byte ptr [ebx] == 0; byte ptr[ebx + edi] == 0	;if the spot is empty
				mWrite "  <Empty Spot>"		;write empty spot
				call Crlf					;newline
				add edi, 128				;add 128 (go forward 128)
				add ebx, 128
				JMP loopBack				;loop in the next sector
			
			.ELSE							;else is not empty
			
				mWrite "  "
				INVOKE putstring, ebx ;[ebx +edi]	    ;else output the contents
				call Crlf	
				;inc esi								;increment the index
				add ebx, 128
				add edi, 128						;advance 128 characters
				
				;call Crlf
				;mWrite "inside the else in add"
				;call Crlf
				
				JMP loopBack						;go back to the loop
					
				call Crlf							;newline
				
			.ENDIF								;end nested if else
		.ELSE
			JMP endProc							;if is the end of the array, escape
		.ENDIF									;end outer ifelse statement
	
	JMP loopBack								;start over

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

	push ebx					;reserve the ebx register
	push ecx					;reserve the ecx register
	push edx					;reserve the edx register
	push esi 					;reserve the esi register
	
	mov ebx, offset bWordArray	;points to the first thing in the stack, in this case is the array
	mov ecx, [ebp + 8]		    ;points to the second thing in the stack, in this case is the string to add
	mov esi, 0				    ;initialize esi to zero
	
	
	;find the correct spot to add the string into
findSpot:
	
	call Check_Spot
	
	.IF eax == -1
		call Crlf
		mWrite "**ERROR String Manager is FULL, please delete a string before adding."
		call Crlf
		JMP endProcedure
	.ENDIF
	
	add ebx, eax	;Have B point to the address within the db range
	
	;Writes each byte directly into the db
toTop:
	push ecx				;push the ecx register
	mov cl, [ecx]			;put whats inside the ecx into the cl
	mov [ebx], cl			;put the cl into the ebx
	pop ecx					;pop the register
	inc ebx					;increase the position
	inc ecx					;increase the string index
	cmp byte ptr [ecx], 0	;When null is reached
	je addNull
	jmp toTop
	
	
addNull:
	mov byte ptr [ebx], 0	;Write the null terminator
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

intasc32 	PROTO Near32 stdcall, lpStringToHold: dword, dval: dword
putstring   PROTO Near32 stdcall, lpStringToPrint: dword
getch 		PROTO Near32 stdcall

	push ebp		
	mov ebp, esp

	push ebx					;reserve the ebx register	
	push ecx					;reserve the ebx register
	push esi
	push edx
	push edi
	
	mov ebx, offset bWordArray	;allocate the array into the ebx
	mov ecx, [ebp + 8]      	;number to delete
	
	;get the start points (use iMul)

	
	mov eax, ecx				;load index into the eax
	mov edx, 128				;put 128 in another register
	imul edx					;multiply the index times 128
	mov esi, eax				;esi now has the starting point
	
	;get the end points (store esi + 128 in a register)		????????????
	mov edi, esi
	add edi, 128				;now the edx has stored the upper boundary			
	
	;while counter is within those boundaries
	;replace the value with zeroes
	;end the program
	
	mov ecx, 0
	mov cl, 0
	
	cmp byte ptr[ebx + esi], 0
	JE empty
	
;Get the array at that position
;confirm edit
		call Crlf
		mWrite "Confirm Deletion Y/N (upper case only): "
		INVOKE getche
		call Crlf
		
		cmp al, 'Y'
		JNE notDeleted
	
	deleteLoop:
	
	mov byte ptr[ebx + esi], 0
	inc esi
	
	.IF edi == esi
		call Crlf
		mWrite "The string was succesfully Deleted"
		call Crlf
		JMP endProcedure
	.ENDIF
		
	JMP deleteLoop
	
	;if the spot is taken
	empty:
		call Crlf
		mWrite "cannot delete empty spot"
		call Crlf
		
	notDeleted:
		call Crlf
		mWrite "The operation was cancelled"
		call Crlf
	
	endProcedure:
	
		pop edi
		pop edx
		pop esi
		pop ecx
		pop ebx
		pop ebp
		
		
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

	; call Crlf
	; mWrite "beginning of the main loop"
	; call Crlf

	;if the counter reaches 1280(the end of the array)
	cmp esi,1280
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
	pop ebp

	RET 
Check_Memory endp

;**********************************************************
;Modify a string in the array
;**********************************************************
String_Edit Proc Near32
	push ebp		
	mov  ebp, esp
	
	push ebx
	push ecx
	push edx				;array
	push esi
	push edi
	
	mov ebx, offset bWordArray
	
	mov ecx, [ebp+12]		;string number 
	
	;get the start points (use iMul)
	
	mov eax, ecx				;load index into the eax
	mov edi, 128				;put 128 in another register
	imul edi					;multiply the index times 128
	mov esi, eax				;esi now has the starting point
	
	mov edi,0
	
	mov edx, [ebp+8]			;string to replace with
	
	;get the end points (store esi + 128 in a register)		????????????
	mov ecx, esi
	add ecx, 128
	mov edi, ecx				;now the edi has stored the upper boundary
								;now ecx is free
						

	
	 cmp byte ptr[ebx + esi] , 0
	 je empty	
	
	
	mov cl, 0

	;confirm edit
		call Crlf
		mWrite "Confirm Edit Y/N (upper case only): "
		INVOKE getche
		call Crlf
		
		cmp al, 'Y'
		JNE notDeleted
	

	writeLoop:		
		mov byte ptr[ebx + esi], 0
		inc esi
		
		cmp esi, edi	;When end is reached
		je aNewHope
		
		JMP writeLoop
		

aNewHope:	

		mov ecx, [ebp+12]		;string number 
				
		;get the start points (use iMul)

		
		mov eax, ecx				;load index into the eax
		mov edi, 128				;put 128 in another register
		imul edi					;multiply the index times 128
		mov esi, eax				;esi now has the starting point
			
		mov edx, [ebp+8]			;string to replace with
	
	push edx
	call String_length
	add esp, 4
	
	;esi has starting point for the array
	;edi is 0
	;edx has the string
	;eax has the string lenght
	
	mov cl, 0
	mov edi, 0
	
writeNewData:

	mov cl, byte ptr[edx+edi]

	.IF edi <= eax
		mov byte ptr[ebx + esi], cl
		inc esi
		inc edi
	.ELSE
		call Crlf
		mWrite "The string was succesfully edited"
		call Crlf
		jmp endProcedure
	.ENDIF
 JMP writeNewData
	
empty:
	call Crlf
	mWrite "The spot is empty, cannot replace the string"
	call Crlf
	
notDeleted:
	call Crlf
	mWrite "The operation was cancelled"
	call Crlf
	
	endProcedure:
	
	 pop edi
	 pop esi
	 pop edx
	 pop ecx
	 pop ebx
	 pop ebp
	
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
;Get the array at that position
; .data
; strBuffer byte 10 dup(?)

; .code

; invoke intasc32, addr strBuffer, eax
; invoke putstring, addr strBuffer
; ;invoke putstring, ecx
;**********************************************************
Get_String Proc Near32
	push ebp
	mov ebp, esp
	
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	mov ebx, offset bWordArray		;array
	mov ecx, [esp+8]				;index start
	
	;get the start points (use iMul)
	
	mov eax, ecx				;load index into the eax
	mov edi, 128				;put 128 in another register
	imul edi					;multiply the index times 128
	mov  esi, eax				;esi now has the starting point
	
	mov edi,0
	
	;get the end points (store esi + 128 in a register)	
	mov edi, esi
	add edi, 128				;now the edi has stored the upper boundary
								;now edx and ecx is free
				
	mov ecx, 0
	loopStart:
		.IF esi <= edi
		
			mov cl, byte ptr[ebx+esi]
			mov [edx], cl
			inc esi
			inc edx
			JMP loopStart
		
		.ELSE
			jmp endProcedure
			
		.ENDIF
	
endProcedure:

	mov eax, edx
	
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop ebp

	
RET


Get_String endp


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
	.ELSEIF esi == 1280
		JMP notFound
		
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
