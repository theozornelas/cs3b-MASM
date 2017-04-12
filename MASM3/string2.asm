String_indexOf_1  proc Near32
push ebp        ;preserve space
mov ebp, esp
push eax        ;character
push ebx        ;string
push esi
mov ebx,[ebp+12]
mov esi, 0

mainLoop:

    cmp byte ptr[ebx + ebp], eax
    JE endMethod

    cmp byte ptr[ebx + ebp], 0    ;reaches the end of the string
    JE endMethod

    inc esi

    loop mainLoop

endMethod:
    mov eax, esi
    pop eax
    pop ebx
    pop esi
    pop ebx
 
    RET

String_indexOf_1 endp

;start of the second method

String_indexOf_2 proc Near32
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx
    push esi
    mov ebx,[ebp+16]
    mov esi, 0

mainLoop:
    cmp byte ptr[eax + esi], ebx ;matches the index
    JE endmepls

    cmp byte ptr[ecx + ebp], 0   ;reaches end of the string
    JE endmepls

    inc esi
    loop mainLoop

endmepls:

    mov eax, esi
    pop eax
    pop ebx
    pop ecx
    pop esi
    pop ebx

RET 

String_indexOf_2 endp       ;end of the function


;start of method 3


;returns the index of first occurrence of specified substring str.
;+String_indexOf_3(string1:String, str:String):int
String_indexOf_3 proc Near32

;hacer un loop, incrementar el esi, si un match ocurre entoces incrementar un segundo counter para el word match. 
;Si el segundo counter es igual al tamaño de la palabra, es un match
;y se sale el programa (tambien si es el final de la palabra)

;empujar el substr
;empujar el main string




RET

String_indexOf_3 endp


;+String_toLowerCase(string1:String):String  
;It converts the string to lower case string

;+String_toUpperCase(string1:String):String   
;It converts the string to upper case string

String_toLowerCase proc Near3

push ebp
mov ebp, esp
 
 push al  ;push string in
 push bl
 push esi ;start counter
 
 mov esi, 0			;initialize to zero
 
 mainLoop:
 
 cmp al[esi], 0
 JE  endthepain
 
 cmp al[esi], 
 
 mov bl, 91
 JB checkupper
 
 checkupper:
    cmp bl, 
 
 ;finish the method
 endthepain:
 
 
	
 
 
 
 RET 
 
String_toLowerCase




