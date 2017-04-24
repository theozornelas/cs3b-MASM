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
		EXTERN String_toLowerCase:Near32
		
		memoryallocBailey	PROTO Near32 stdcall, dNumBytes:dword
		putstring			PROTO Near32 stdcall, lpStringToPrint:dword
		intasc32			PROTO Near32 stdcall, lpStringToHold:dword, dval:dword
		
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
	
	
;	+String_equalsIgnoreCase(string1:String,string2:String):boolean
String_equalsIgnoreCase PROC Near32
	push EBP					; preserve the EBP
	mov  EBP, ESP				; set new stack frame
	push EBX					; preserve EBX
	push ECX					; preserve ECX
	
	push [EBP + 8]				; push string1 onto Stack
	call String_toLowerCase		; call String_toLowerCase on string1
	add  ESP, 4					; re-adjusting ESP after call 
	mov  EBX, EAX				; EBX = String_toLowerCase(string1)
	
	push [EBP + 12]				; push string2 onto Stack
	call String_toLowerCase		; call String_toLowerCase on string2
	add  ESP, 4					; re-adjusting ESP after call
	mov  ECX, EAX				; ECX = String_toLowerCase(string2)
	
	push ECX					; push String_toLowerCase(string2) onto Stack
	push EBX					; push String_toLowerCase(string1) onto Stack
	call String_equals			; call String_equals on the two above arguments
	add  ESP, 8					; re-adjusting ESP after call
	
	pop ECX						; restore ECX
	pop EBX						; restore EBX
	pop EBP						; restore EBP (stack frame from before function call)
	RET
String_equalsIgnoreCase ENDP
	
	
;	+String_copy(string1:String):String   => +String_copy(lpStringToCopy:dword):dword
String_copy PROC Near32
	push EBP						; preserve the EBP
	mov  EBP, ESP					; set new stack frame
	push EBX						; preserve EBX
	push ECX						; preserve ECX
	push EDX						; preserve EDX
	push ESI						; preserve ESI
	
	mov EBX, [EBP + 8]				; EBX = string1
	
	push EBX						; push string1 onto Stack
	call String_length				; call String_length on string1
	add  ESP, 4						; re-adjusting ESP after call
	mov  ECX, EAX					; ECX = String_length(string1)
	inc  ECX						; ECX++ (to account for null-terminator)
	
	INVOKE memoryallocBailey, ECX	; allocate String_length(string1) # of bytes into EAX
	mov EDX, EAX					; move address of dynamically allocated memory into EDX
	
	mov ESI, 0						; ESI = 0
	
copyLoop:
	mov AL, byte ptr [EBX+ESI]		; AL = string1[ESI]
	mov byte ptr [EDX+ESI], AL		; EDX[ESI] = string1[ESI]
	
	inc ESI							; ESI++
	cmp ESI, ECX					; ESI == ECX ?
	jne copyLoop					; if not equal, jump back to copyLoop
	
	mov EAX, EDX					; EAX = copy of string1
	pop ESI							; restore ESI
	pop EDX							; restore EDX
	pop ECX							; restore ECX
	pop EBX							; restore EBX
	pop EBP							; restore EBP
	RET
String_copy ENDP
	

;	+String_substring_1(string1:String,beginIndex:int,endIndex:int):String
String_substring_1 PROC Near32
	push EBP						; preserve the EBP
	mov  EBP, ESP					; set new stack frame
	push EBX						; preserve EBX
	push ECX						; preserve ECX
	push EDX						; preserve EDX
	push ESI						; preserve ESI
	push EDI						; preserve EDI
	
	mov EBX, [EBP + 8]				; EBX = string1
	mov ESI, [EBP + 12]				; ESI = beginIndex
	mov EDI, [EBP + 16]				; EDI = endIndex
	
	cmp ESI, EDI					; beginIndex >= endIndex ?
	jge invalidIndices				; if greater than or equal to, jump to invalidIndices
	
	cmp ESI, 0						; beginIndex < 0 ?
	jb  invalidIndices				; if beginIndex < 0 (negative), jump to invalidIndices
	
	cmp EDI, 0						; endIndex < 0 ?
	jb  invalidIndices				; if endIndex < 0 (negative), jump to invalidIndices
	
	push EBX						; push string1 onto Stack
	call String_length				; call String_length on string1
	add  ESP, 4						; re-adjusting ESP after call
	
	cmp ESI, EAX					; beginIndex >= String_length(string1) ?
	jge invalidIndices				; if greater than or equal to, jump to invalidIndices
	
	cmp EDI, EAX					; endIndex > String_length(string1) ?
	jg invalidIndices				; if greater than, jump to invalidIndices
	
	mov ECX, EDI					; ECX = endIndex
	sub ECX, ESI					; ECX -= beginIndex
	inc ECX							; ECX++ (to account for null-terminator)
	
	INVOKE memoryallocBailey, ECX	; allocate String_length(string1) # of bytes into EAX
	mov EDX, EAX					; move address of dynamically allocated memory into EDX
	
	mov ECX, 0						; ECX = 0
	
substrLoop:
	mov AL, byte ptr [EBX+ESI]		; AL = EBX[ESI]
	mov byte ptr [EDX+ECX], AL		; EDX[ECX] = EBX[ESI]
	
	inc ESI							; ESI++
	inc ECX							; ECX++
	
	cmp ESI, EDI					; ESI == endIndex ?
	je  nullTerminateStr			; if equal, jump to nullTerminateStr
	jne substrLoop					; otherwise, jump back to substrLoop
	
invalidIndices:
	INVOKE memoryallocBailey, 1		; allocate 1 byte into EAX (return string will be null)
	jmp finished					; jump to finished
	
nullTerminateStr:
	mov byte ptr [EDX+ESI], 0		; move null-terminator at end of EDX (return string)
	mov EAX, EDX					; EAX = EDX (return string)
	
finished:
	pop EDI							; restore EDI
	pop ESI							; restore ESI
	pop EDX							; restore EDX
	pop ECX							; restore ECX
	pop EBX							; restore EBX
	pop EBP							; restore EBP (stack frame from before function call)
	RET
String_substring_1 ENDP


;	+String_substring_2(string1:String,beginIndex:int):String
String_substring_2 PROC Near32
	push EBP					; preserve the EBP
	mov  EBP, ESP				; set new stack frame
	push EBX					; preserve EBX
	push ECX					; preserve ECX
	push EDX					; preserve EDX
	
	mov EBX, [EBP + 8]			; EBX = string1
	mov ECX, [EBP + 12]			; ECX = beginIndex
	
	push EBX					; push string1 onto Stack
	call String_length			; call String_length on string1
	add  ESP, 4					; re-adjusting ESP after call
	
	mov EDX, EAX				; EDX = String_length(string1)
	
	push EDX					; push EDX ("endIndex") onto Stack
	push ECX					; push ECX (beginIndex) onto Stack
	push EBX					; push string1 onto Stack
	call String_substring_1		; call String_substring_1 on string1, beginIndex, "endIndex"
	add  ESP, 12				; re-adjusting ESP after call
	
	pop EDX						; restore EDX
	pop ECX						; restore ECX
	pop EBX						; restore EBX
	pop EBP						; restore EBP (stack frame from before function call)
	RET
String_substring_2 ENDP


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
	jb  invalidPosition			; if position < 0 (negative), jump to invalidPosition
	
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
	
	mov EBX, 0					; EBX = 0
	
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
	push EAX					; push EAX ("pos") onto Stack
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