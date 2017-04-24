;***********************************************
; Program Name:		String1.asm
; Programmers:		Arang Christopher Montazer
; Class: 			CS3B
; Date:				3-28-17
; 
; Purpose:			string methods
;***********************************************

		.486
		.model flat
		
		EXTERN String_length:Near32
		
		.code
		
;	+String_equals(string1:String,string2:String):boolean   (byte)
String_equals PROC Near32
	push EBP					; preserve the EBP
	mov  EBP, ESP				; set new stack frame
	push EBX					; preserve EBX
	push ECX					; preserve ECX
	push EDX					; preserve EDX
	push ESI					; preserve ESI
	
	push [EBP + 8]				; push string1 onto Stack
	call String_length			; call String_length on string1
	add  ESP, 4					; re-adjusting ESP after call
	mov  EBX, EAX				; EBX = String_length(string1)
	
	push [EBP + 12]				; push string2 onto Stack
	call String_length			; call String_length on string2
	add  ESP, 4					; re-adjusting ESP after call
	mov  EDX, EAX				; EDX = String_length(string2)
	
	cmp EBX, EDX				; String_length(string1) == String_length(string2) ?
	jne notEqualStrings			; if not equal, jump to notEqualStrings
	
	mov ECX, EDX				; ECX = String_length(string2)
	mov EBX, [EBP + 8]			; EBX = string1
	mov EDX, [EBP + 12]			; EDX = string2
	mov ESI, 0					; ESI = 0

checkStrIndices:
	mov AL, [EBX+ESI]			; AL = string1[ESI]
	mov AH, [EDX+ESI]			; AH = string2[ESI]
	cmp AL, AH					; string1[ESI] == string2[ESI] ?
	jne notEqualStrings			; if not equal, jump to notEqualStrings
	inc ESI						; ESI++
	cmp ESI, ECX				; ESI == ECX ?
	je  equalStrings			; if equal, jump to equalStrings
	jne checkStrIndices			; if not equal, continue loop
	
notEqualStrings:
	mov AL, 0					; AL = 0 (false)
	jmp finished				; jump to finished
	
equalStrings:
	mov AL, 1					; AL = 1 (true)
	
finished:
	pop ESI						; restore ESI
	pop EDX						; restore EDX
	pop ECX						; restore ECX
	pop EBX						; restore EBX
	pop EBP						; restore EBP (stack frame from before function call)
	RET
String_equals ENDP
	
	
;	+String_charAt(string1:String,position:int):char (byte)
String_charAt PROC Near32
	push EBP					; preserve the EBP
	mov  EBP, ESP				; set new stack frame
	push EBX					; preserve EBX
	push ECX					; preserve ECX
	push EDX					; preserve EDX
	
	mov EBX, [EBP + 8]			; EBX = string1
	mov ECX, [EBP + 12]			; ECX = position
	
	push EBX					; push string1 onto Stack
	call String_length			; call String_length on string1
	add  ESP, 4					; re-adjusting ESP after call
	mov  EDX, EAX				; EDX = String_length(string1)
	
	cmp ECX, 0					; compares position against 0
	jb  invalidPosition			; if position < 0 (negative), jump to invalidPosition
	
	cmp ECX, EDX				; compares position against String_length(string1)
	jge invalidPosition			; if position >= String_length(string1), jump to invalidPosition
	
	mov AL, byte ptr [EBX+ECX]	; if valid position, move char at given position into AL
	jmp finished				; jump to finished
	
invalidPosition:
	mov AL, -1					; AL = -1 (because of invalid position)
	jmp finished				; jump to finished
	
finished:
	pop EDX						; restore EDX
	pop ECX						; restore ECX
	pop EBX						; restore EBX
	pop EBP						; restore EBP (stack frame from before function call)
	RET	
String_charAt ENDP


;	+String_startsWith_1(string1:String,strPrefix:String, pos:int):boolean
String_startsWith_1 PROC Near32
	push EBP					; preserve the EBP
	mov  EBP, ESP				; set new stack frame
	push EBX					; preserve EBX
	push ECX					; preserve ECX
	push EDX					; preserve EDX
	push ESI					; preserve ESI
	push EDI					; preserve EDI
	
	mov ECX, 0					; ECX = 0
	mov EDI, [EBP + 8]			; EDI = string1
	mov EDX, [EBP + 12]			; EDX = strPrefix
	mov ESI, [EBP + 16]			; ESI = position
	
	cmp ESI, 0					; compares position against 0
	jb invalidPosition			; if position < 0 (negative), jump to invalidPosition
	
	push EDI					; push string1 onto Stack
	call String_length			; call String_length on string1
	add  ESP, 4					; re-adjusting ESP after call
	mov  CL, AL					; CL = String_length(string1)
	
	cmp ESI, ECX				; compares position against String_length(string1)
	jge invalidPosition			; if position >= String_length(string1), jump to invalidPosition
	
	push EDX					; push strPrefix onto Stack
	call String_length			; call String_length on strPrefix
	add  ESP, 4					; re-adjusting ESP after call
	mov  CH, AL					; CH = String_length(strPrefix)
	
	cmp CH, CL					; String_length(strPrefix) > String_length(string1) ?
	jg  prefixTooLong			; if length of prefix is greater than string1, jump to prefixTooLong
	
	mov EBX, 0
	
strLoop:
	cmp BL, CH					; BL == String_length(strPrefix) ?
	je  true					; if equal, jump to true
	
	mov AL, byte ptr [EDX+EBX]	; AL = strPrefix[EBX]
	mov AH, byte ptr [EDI+ESI]	; AH = string1[ESI]
	
	INC EBX						; EBX++
	INC ESI						; ESI++
	
	cmp AL, AH					; strPrefix[ESI] == string1[ESI] ?
	je  strLoop					; if equal, jump back to strLoop
	jne false					; if not equal, jump to false
	
prefixTooLong:
invalidPosition:
	mov AL, -1					; AL = -1 (because of invalid position)
	jmp finished				; jump to finished
	
true:
	;mov EAX, 0					; reset EAX to 0
	mov EAX, 1					; AL = 1 (true)
	jmp finished				; jump to finished
	
false:
	mov EAX, 0					; reset EAX to 0 (false)
	
finished:
	pop EDI						; restore EDI
	pop ESI						; restore ESI
	pop EDX						; restore EDX
	pop ECX						; restore ECX
	pop EBX						; restore EBX
	pop EBP						; restore EBP (stack frame from before function call)
	RET

String_startsWith_1 ENDP


;	+String_startsWith_2(string1:String, strPrefix:String):boolean
String_startsWith_2 PROC Near32
	push EBP					; preserve the EBP
	mov  EBP, ESP				; set new stack frame

	mov  EAX, 0					; EAX = 0
	push EAX					; push EAX onto Stack
	push [EBP + 12]				; push strPrefix onto Stack
	push [EBP + 8]				; push string1 onto Stack
	call String_startsWith_1	; call String_startsWith_1 with string1, strPrefix, and 0
	add ESP, 12					; re-adjusting ESP after call
	
	pop EBP						; restore EBP (stack frame from before function call)
	RET
String_startsWith_2 ENDP

;	+String_endsWith(string1:String, suffix:String):boolean
String_endsWith PROC Near32
	push EBP					; preserve the EBP
	mov  EBP, ESP				; set new stack frame
	push EBX					; preserve EBX
	push ECX					; preserve ECX
	push EDX					; preserve EDX
	
	mov EBX, [EBP + 8]			; EBX = string1
	mov ECX, [EBP + 12]			; ECX = suffix
	
	push EBX					; push string1 onto Stack
	call String_length			; call String_length with string1
	add  ESP, 4					; re-adjusting ESP after call
	mov  EDX, EAX				; EDX = String_length(string1)
	
	push ECX					; push suffix onto Stack
	call String_length			; call String_length with suffix
	add  ESP, 4					; re-adjusting ESP after call
	sub  EDX, EAX				; EDX -= String_length(suffix)
	
	push EDX					; push EDX (position) onto Stack
	push ECX					; push ECX (suffix --> strPrefix) onto Stack
	push EBX					; push EBX (string1)
	call String_startsWith_1	; call String_startsWith_1 with string1, suffix, and EDX
	add  ESP, 12				; re-adjusting ESP after call
	
	pop EDX						; restore EDX
	pop ECX						; restore ECX
	pop EBX						; restore EBX
	pop EBP						; restore EBP (stack frame from before function call)
	RET
String_endsWith ENDP
	END