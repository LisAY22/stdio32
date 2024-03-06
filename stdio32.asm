; bloque de funciones para entrada y salida standar
; autor: lis
; fecha: 20240223

;----------------int strLen(cadena)--------------------
; recibe cadena en eax y devuelve longitud en eax
strLen:
        push    ebx
        mov     ebx, eax

sigCaracter:
        cmp     byte [eax], 0
        jz      finStrLen
        inc     eax
        jmp     sigCaracter

finStrLen:
        sub     eax, ebx
        pop     ebx
        ret

;---------------strPrint(cadena)-------------------------
; imprime cadena en pantalla, recibe cadena en eax
strPrint:
        push    edx
        push    ecx
        push    ebx
        push    eax

	call    strLen
        mov     edx, eax
        pop     eax
        mov     ecx, eax
        mov     ebx, 1
        mov     eax, 4
        int     80h

        pop     ebx
        pop     ecx
        pop     edx

        ret

;----------------strPrintLn(cadena)
; imprime cadena en pantalla, la cadena se recibe en eax
; y agrega salto de linea en la impresion
strPrintLn:
        call    strPrint
        push    eax
        mov     eax, 0Ah                ; eax = 0AH
        push    eax                     ; colocamos el valor de eax en pila
        mov     eax, esp                ; eax aputna a esp (posicion de iniicio de pil>
        call    strPrint
        pop     eax
        pop     eax
        ret

;---------------strInput(cadena)
; lectura de cadena ingresada por el teclado
strInput:
	push    edx
        push    ecx
        push    ebx
        push    eax
        mov     edx,20                          ;edx = espacio para lectura
        mov     ecx,ebx                      ;ecx = dir. de mem para alma>
        mov     ebx,0                           ;leer desde STDIN
        mov     eax,3                           ;servicio SYS_READ
        int     80h

        pop     eax
        pop     ebx
        pop     ecx
	pop 	edx
	ret

upCase:

        UCCicle:
                mov     al, [esi]
                cmp     al, 0
                je      finStr
                cmp     al, 'a'
                jl      noMinus

                cmp     al, 'z'
                jg      noMinus

                jmp     Minus
        noMinus:
                mov     [edi], al
                inc     edi
                jmp     nextUCh

	Minus:
                sub     al, 32
                mov     [edi], al
                inc     edi
        nextUCh:
                inc     esi
                jmp     UCCicle

loCase:

        LCCicle:
                mov     al, [esi]
                cmp     al, 0
                je      finStr
                cmp     al, 'A'
                jl      noMayus
                cmp     al, 'Z'
                jg      noMayus
                jmp     Mayus

	noMayus:
                mov     [edi], al
                inc     edi
                jmp     nextLCh
        Mayus:
                add     al, 32
                mov     [edi], al
                inc     edi

        nextLCh:
                inc     esi
                jmp     LCCicle


finStr:
        ret

printIntLn:
        push    eax
        push    ecx
        push    ebx

        mov     eax, ebx
        xor     ecx, ecx
        call    divideNumber
        call    printDigit

        mov     eax, 0Ah
        push    eax
        mov     eax, esp
        call    strPrint

	pop     eax
        pop     ebx
        pop     ecx
        pop     eax
        ret

printInt:
        push    eax
        push    ebx
        push    ecx

	mov     eax, ebx
        xor     ecx, ecx
        call    divideNumber
        call    printDigit

        pop     eax
        pop     ebx
        pop     ecx
        ret

divideNumber:
        inc     ecx
        xor     edx, edx
        mov     ebx, 10
        idiv    ebx
        push    edx
        cmp     eax, 0
	jne     divideNumber

printDigit:
        cmp     ecx, 0
        jz      finStr
        dec     ecx
        pop     edx
        add     edx, 48
        push    edx
        mov     eax, esp
        call    strPrint
        pop     eax
        xor     eax, eax
        jmp     printDigit

;--------------Quit
; cerrar el programa
Quit:
        mov     ebx, 0
        mov     eax, 1
        int     80h
        ret

