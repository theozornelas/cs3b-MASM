;***********************************************
; Program Name:		String1.asm
; Programmers:		Osvaldo Moreno Ornelas
; Class: 			CS3B
; Date:				3-28-17
; 
; Purpose:			string methods
;***********************************************

		.486
		.model flat
		
		EXTERN String_length:Near32
		EXTERN String_substring_1:Near32
		EXTERN String_startsWith_1:Near32
		
		memoryallocBailey	PROTO Near32 stdcall, dNumBytes:dword
		;EXTERN String_toLowerCase:Near32
		
		.code
		

;+String_toLowerCase(string1:String):String  
;It converts the string to lower case string
String_toLowerCase proc Near32

	push  ebp			;preserve
	mov   ebp, esp		;stack frame
 
	push ebx		;word to be converted to lower case
	push ecx		;stores string to be returned
	push edx		;stores temp char (dl)
	push esi 		;counter
 
	mov esi, 0		;initialize to zero
 
	mov ebx, [ebp + 8] ;get data in that position and put into the ebx
 
	push ebx
	call String_length
	add esp, 4
 
	inc eax
	INVOKE memoryallocBailey, eax
	
	mov ecx, eax
	
	mainLoop:
 
	;cmp ebx, 0			;if there is nothing
 
		cmp byte ptr [ebx + esi], 0
		JE endthepain		;end the procedure
 
		cmp byte ptr [ebx + esi], 91d    ;if less than 91 (have to use byte ptr because we are comparing byte vs byte)
		JB checklowerbound
		
		mov dl, [ebx + esi]
		;add dl, 32
		mov [ecx + esi], dl
 
 ;other wise just move past it to the next character
	inc esi					;increment counter
	JMP mainLoop 			;start the comparison again
 
	checklowerbound:
		cmp byte ptr [ebx + esi], 64d			;if greater than 64
		JA  convertToLower	;go to convert character
	
		;if not valid then just move past it
		;JMP endthepain
	
		mov dl, [ebx + esi]
		;add dl, 32
		mov [ecx + esi], dl
	
		inc esi
		JMP mainLoop
	
	;convert the character by adding 32 to it
	convertToLower:
		mov dl, [ebx + esi]
		add dl, 32
		mov [ecx + esi], dl
	
		inc esi
		JMP mainLoop
 
	;finish the method
	endthepain:
 
		;add null terminator to the string
		mov al, 0
		mov[ecx+esi], al
		
		;mov string into the eax
		mov eax, ecx
 
		pop esi
		pop edx
		pop ecx
		pop ebx
		pop ebp
    
	RET 
 
String_toLowerCase endp


;+String_toUpperCase(string1:String):String   
;It converts the string to upper case string

String_toUpperCase proc Near32

	push  ebp			;preserve
	mov   ebp, esp		;stack frame
 
	push ebx		;word to be converted to lower case
	push ecx		;stores string to be returned
	push edx		;stores temp char (dl)
	push esi 		;push counter
 
	mov esi, 0		;initialize to zero
 
	mov ebx, [ebp + 8] ;get data in that position and put into the ebx
 
 
	push ebx
	call String_length
	add esp, 4
 
	inc eax
	INVOKE memoryallocBailey, eax
	
	mov ecx, eax
 
mainLoop:
 
		;cmp ebx, 0			;if there is nothing
		cmp byte ptr [ebx + esi], 0
		JE endthepain		;end the procedure
 
		cmp byte ptr [ebx + esi], 123d    ;if less than 91 (have to use byte ptr because we are comparing byte vs byte)
		JB checklowerbound
 
		mov dl, [ebx + esi]
		;add dl, 32
		mov [ecx + esi], dl
 
 ;other wise just move past it to the next character
 
	inc esi						;increment counter
	JMP mainLoop 					;start the comparison again
 
checklowerbound:
		cmp byte ptr [ebx + esi], 96d			;if greater than 64
		JA  convertToLower	;go to convert character
	
		;if not valid then just move past it
		;JMP endthepain
	
		mov dl, [ebx + esi]
		;add dl, 32
		mov [ecx + esi], dl
	
		inc esi
		JMP mainLoop
	
	;convert the character by adding 32 to it
convertToLower:
		mov dl, [ebx + esi]
		sub dl, 32
		mov [ecx + esi], dl
	
		inc esi
		JMP mainLoop
 
	;finish the method
endthepain:
 
		;add value into the eax
	;add null terminator to the string
		mov al, 0
		mov[ecx+esi], al
		
		;mov string into the eax
		mov eax, ecx
 
		pop esi
		pop edx
		pop ecx
		pop ebx
		pop ebp
    
	RET 
 
String_toUpperCase endp 

		
;+String_indexOf_1(string1:String,ch:char):int 
; Returns the index of first occurrence of the specified character ch in the string.
String_indexOf_1  proc Near32
	
	push ebp        ;preserve space
	mov  ebp, esp
	
	push ebx        ;character
	push ecx        ;string
	
	mov bl, 	[ebp + 12]
	mov ecx, [ebp + 8]
	
	push esi
	mov  esi, 0

mainLoop:

	cmp byte ptr[ecx + esi], bl
	JE endMethod

	cmp byte ptr[ecx + esi], 0    ;reaches the end of the string
	JE returnFalse

	inc esi

	JMP mainLoop

returnFalse:
	mov esi, -1
	
endMethod:
	mov eax, esi
	
	pop esi
	pop ecx
	pop ebx
	pop ebp
	
 
    RET

String_indexOf_1 endp

;****************************************************************
;+String_indexOf_2(string1:String,ch:char,fromIndex:int):int    
;Same as indexOf method however it starts searching in the 
;string from the specified fromIndex.
;****************************************************************

String_indexOf_2 proc Near32
   
	push ebp
    mov ebp, esp
	
    push ebx	;substring
    push ecx	;char search
    push edx	;main string
    push esi	;max size / counter
	push edi    ;index
    
	mov edx,  [ebp +  8] ;string
	mov cl ,  [ebp + 12] ;char
	mov edi , [ebp + 14] ;index
	
	;take string lenght
	
	push edx
	call String_length
	add esp, 4
	
	mov esi, eax   ;esi has the lenght of string stores in the edx
	
	
	;take the substring
	;push data into the stack
	push esi
	push edi
	push edx
	call String_substring_1
	
	add esp, 12
	
	mov ebx, eax   ;ebx has substring now
	
	;avoid using cx ecx
	
	;inc edi
	;INVOKE memoryallocBailey, edi
	
	;eax has edi amount of bytes allocated

	;initialize the esi to 0
	mov esi, 0

;this loop goes through the string from the tha back to the front
mainLoop:

	;compare current char to the one past in
	cmp byte ptr[ebx + esi], cl
	JE endmepls									;if equal end the program(found)
	
	;if not found (reached the end of the string)
	cmp byte ptr[ebx + esi], 0
	JE notFound									;go to default value label
	
    inc esi										;increase the esi
	JMP mainLoop								;loop back

notFound:
	mov esi, -1									;if not found -1 will be returned

endmepls:

    mov eax, esi								;store result in the eax
 
 ;pop from the stack
    pop edi
    pop esi
    pop edx
    pop ecx
	pop ebx
	
	pop ebp

RET 

String_indexOf_2 endp       ;end of the function

;*******************************************************
;+String_indexOf_3(string1:String, str:String):int   
;This method returns the index of first occurrence of 
;specified substring str.
;*******************************************************
String_indexOf_3 proc Near32

;preserve registers
	push ebp
    mov ebp, esp
	
	push ebx     ;str to find
	push ecx     ;main string
	
	push esi     ;position

	mov ecx, [ebp + 12]   ;allocate the str to find
	mov ebx, [ebp + 8]	  ;allocate the main string
	
	mov esi, 0


	;loop that iterates through the string
mainLoop:

	cmp byte ptr [ebx+esi], 0 ;is the end of the string
	JE notInString			 ;if never found got to the label

	;preserve the registers for procedure
	push esi
	push ecx
	push ebx
	
	call String_startsWith_1	;call starts with procedure

	add esp, 12					;add 12 to the esp
	
	cmp al, 1					;if eax == 1(found) end the loop
	JE  endThePain
	
	JNE increaseCounter			;else increase the counter
	
increaseCounter:
	inc esi						;increase number then go to the main loop
	JMP mainLoop
	
	;if is not found in the string then put -1 in the esi
notInString:
	mov esi, -1
	
	;ending procedures
endThePain:
	mov eax, esi				;if put the index in the eax (value to be returnd)
	
	;pop registers to clear the stack
	pop esi
	pop ecx
	pop ebx
	pop ebp


RET

String_indexOf_3 endp


;*********************************************************************************
;+String_replace(string1:String,oldChar:char,newChar:char):String  
;It returns the new updated string after changing all the occurrences of oldChar 
;with the newChar.
;
;*********************************************************************************

String_replace proc Near32

;preserve memory in the stack
	push ebp
    mov ebp, esp
	
	push ebx
	push ecx
	push edx  
	
	push esi
	push edi
	
	;assign values in the registers
	mov edx, [ebp + 8]    ;Da string	
	mov cx , [ebp + 12]   ;newChar
	mov bx , [ebp + 14]   ;oldChar
	
	mov esi, 0
	
	;push edx
	;call String_length
	;add esp, 4
	
	;INVOKE memoryallocBailey, eax  ;make a string the same lenght as edx
	
	;inc eax
	;mov esi, eax
	
	
	;linear serach for the character
checkChar:

	cmp byte ptr[edx + esi], cl		;if the characters match
	JE replace						;go to the replace label
			
	;check if never found
	cmp byte ptr[edx + esi], 0 ;is the end
	JE endmepls				   ;since never found, go to end procedure label
		
	inc esi					   ;increase the counter
	JMP checkChar			   ;loop back
		
		;here the character gets replaced
replace:
	mov [edx + esi], bl			;move the new character into position
		
	inc esi						;increment the counter
	JMP checkChar				;loop back to main loop

;terminate and pop
endmepls:	
	
	;put the value in the eax
	mov eax, edx

	;clean the stack
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop ebp


	RET
String_replace endp

;*******************************************************
;+String_concat(string1:String,str:String):String  
;
;*******************************************************
String_concat proc Near32

;preserve memory
	push ebp
    mov ebp, esp
	
	push ebx   ;string1
	push ecx   ;string2
	push esi   ;counter
	push edi   ;size of alloc bailey
	push edx
	
	;link the registers to the values
	mov ebx, [ebp + 12]
	mov ecx, [ebp + 8]
	
	;make a new string
	push ebx					;push into the stack
	call String_length			;call procedure
	add esp, 4					;add 4 to the esp
	
	mov edi, eax				;store size intop the esi
	
	push ecx					;get the second lenght
	call String_length			;call procedure
	add esp, 4					;add 4 to the esp
	
	add edi, eax				;store into the edi
	
	add edi, 1					;add 1 for null terminator
	
	INVOKE memoryallocBailey, 61 ;reserved size in the eax of the size of the edi
	
	mov edx, eax				;store new memory into the edx register
	
	mov eax, 0					;set the register back to zero
	
	mov edi, 0	   				;set the register = 0 (k=0)
	mov esi, 0    				;set the register = 0 (i=0)
	
	
	;else join them (loop char by char and add to new string)
	firstStrLoop:
		
		mov al, [ebx + esi]		;store the value into the al
		cmp al, 0				;if the value is empty, then reset the counter
		JE reset				;jump to reset label
		mov [edx+edi],al		;else move char into the edx (will store returned string)
		
		;add dl to new string
		inc esi 				;increse counter
		inc edi					;increase co counter
		JMP firstStrLoop		;loop back
	 
	 reset:						;reset main iterator to zero
	 mov esi, 0
	 
	 ;same as the first loop, but this time on the second string
	secondStrLoop:
		;cmp byte ptr[ecx + esi], 0
		
		mov al, [ecx + esi]  
		cmp al, 0
		JE endThePain
		mov [edx+edi], al
		
		;add dl to new string
		inc esi
		inc edi
		JMP secondStrLoop
	
	;ending procedures that have to be done
endThePain:

	;add null terminator
	mov al, 0
	mov [edx+edi], al

	;move edx into eax (assign return value into return register)
	mov eax, edx
	
	;clear the stack and do all the popping

	pop edx
	pop edi
	pop esi
	pop ecx
	pop edx
	pop ebp

	RET

String_concat endp


 ;*************************************************
 ;+String_lastIndexOf_1(string1:String, ch:char):int   
 ;It returns the last occurrence of the character 
 ;ch in the string.
 ;*************************************************
String_lastIndexOf_1 proc Near32
	push ebp
	mov  ebp, esp
	
	push ebx		;character
	push ecx		;string
	
	push esi        ;counter
	
	mov ecx, [ebp + 8]
	mov bl,  [ebp + 12]
	
	push ecx
	call String_length
	
	add esp, 4
	
	mov esi, eax		;esi is the same size as the string
	
	;will keep looping until the esd of the string
	mainLoop:

		;cmp byte ptr[ecx+esi], 0 ;if the string is null
		;JE returnNeg
		
		
		
		cmp esi, -1				 ;if there are no more iterations
		JE returnNeg
		
		cmp byte ptr[ecx + esi], bl
		JE endThePain
		
		dec esi
		
		JMP mainLoop
	
	returnNeg:
		mov esi, -1
		
	endThePain:
	
		mov eax, esi
		
		pop esi
		pop ecx
		pop ebx
		pop ebp
	
	RET

String_lastIndexOf_1 endp

;*******************************************************************
;+String_lastIndexOf_2(string1:String,ch:char,fromIndex:int):int  
;Same as lastIndexOf_1 method, but it starts search from fromIndex.
;
;*******************************************************************
String_lastIndexOf_2 proc Near32

;preserve the registers
	push ebp
    mov  ebp, esp
	
    push ebx	;substring
    push ecx	;char search
    push edx	;main string
    push esi	;max size / counter
	push edi    ;index
    
	;add the value to the register
	mov edx,  [ebp +  8] ;string
	mov cl ,  [ebp + 12] ;char
	mov edi , [ebp + 14] ;index
	
	;take string lenght
	push edx
	call String_length
	add esp, 4
	
	mov esi, eax   ;esi has the lenght of string stores in the eax
	
	;take the substring
	push esi
	push edi
	push edx
	call String_substring_1
	
	add esp, 12					;increase the esp by 12
	
	mov ebx, eax   ;ebx has substring now
	
	
	sub esi, edi	;make the counter the size of the substring
	
mainLoop:
									
	cmp byte ptr[ebx + esi], cl			;if the character is found then end the procedure
	JE endmepls
	
	;cmp byte ptr[ebx + esi], 0
	;JE notFound
	
	cmp esi,-1							;if it reaches one before the beginning
	JE notFound
	
    dec esi								;decrease the esi
	JMP mainLoop						;loop again

	;if not found give the default value of -1
notFound:
	mov esi, -1

	;end the procedure and liberate the stack
endmepls:

	add esi, edi
    mov eax, esi
 
    pop edi
    pop esi
    pop edx
    pop ecx
	pop ebx
	
	pop ebp
RET

String_lastIndexOf_2 endp


;*********************************************************
;+String_lastIndexOf_3(string1:String,str:String):int  
;Returns the index of last occurrence of string str.
;*********************************************************

String_lastIndexOf_3 proc Near32
	push ebp
    mov ebp, esp
	
	push ebx     ;str to find
	push ecx     ;main string
	
	push esi     ;position

	mov ecx, [ebp + 12]   ;allocate the str to find
	mov ebx, [ebp + 8]	  ;allocate the main string
	
	
	push ecx
	call String_length
	
	add esp, 4
	
	mov esi, eax


	
mainLoop:

	;cmp byte ptr [ebx+esi], 0;is the end of the string
	;JE notInString
	push esi
	push ecx
	push ebx
	
	call String_startsWith_1

	add esp, 12
	
	cmp al, 1
	JE  endThePain
	JNE decreaseCounter
	
decreaseCounter:
	dec esi
	JMP mainLoop
	
notInString:
	mov esi, -1
	
endThePain:
	mov eax, esi
	
	pop esi
	pop ecx
	pop ebx
	pop ebp


RET


String_lastIndexOf_3 endp
END