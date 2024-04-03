; Bloque de funciones para entrada y salida estandar
; Autor: lis
; Fecha: 20240308

; ---------- strLen ----------
; Calcula longitud de cadena
; Recibe cadena en eax
; Devuelve longitud en eax
strLen:
	push 	ebx

	mov	ebx, eax

sigCaracter:
	cmp	byte[eax], 0
	jz	finstrLen				; jump if zero
	inc	eax
	jmp 	sigCaracter

finstrLen:
	sub	eax, ebx

	pop	ebx

	ret

; ---------- strPrint ----------
; Imprime cadena en pantalla
; Recibe cadena en eax
strPrint:
	push	edx
	push 	ecx
	push 	ebx
	push 	eax

	call	strLen
	mov	edx, eax
	pop	eax
	mov	ecx, eax
	mov	ebx, 1
	mov	eax, 4
	int	80h

	pop	ebx
	pop	ecx
	pop	edx

	ret

; ---------- strPrintLn ----------
; Imprimir cadena en pantalla y agrega salto de linea
; Recibe cadena en eax
strPrintLn:
	call	strPrint
	push	eax
	mov	eax, 0Ah
	push    eax
        mov     eax, esp				; esp - apuntador de pila - cabeza
        call    strPrint
        pop     eax
        pop     eax
        ret

; ---------- strInput ---------
; Lectura de cadena
strInput:
	push    edx
        push    ecx
        push    ebx
        push    eax

        mov     edx, 20
        mov     ecx, ebx
        mov     ebx, 0
        mov     eax, 3
        int     80h

        pop     eax
        pop     ebx
        pop     ecx
        pop     edx
        ret

; ---------- printInt ---------
; Imprime enteros en pantalla
printInt:
	push    eax
        push    ecx
        push    ebx

        mov     ebx, 10
        xor     ecx, ecx
        call    divideNumber
        call    printDigit

        pop     ebx
        pop     ecx
        pop     eax
        ret

; Operacion para obtener el entero de cada digito
divideNumber:
        inc     ecx
        xor     edx, edx			; Limpiar edx
        idiv    ebx				; eax/ebx
        push    edx
        cmp     eax, 0
        jne     divideNumber			; jump if not equal

printDigit:
        cmp     ecx, 0
        jz      finStr
        dec     ecx
        pop     edx
        add     edx, 48				; Convertir a ASCII
        push    edx
        mov     eax, esp
        call    strPrint
        pop     eax
        xor     eax, eax
        jmp     printDigit

finStr:
        ret

; ---------- printIntLn ----------
; Imprime enteros en pantalla y agrega salto de linea
printIntLn:
	call 	printInt

        push    eax

        mov     eax, 0Ah
        push    eax
        mov     eax, esp
        call    strPrint

        pop     eax
        pop     eax
        ret

; ---------- upCase ----------
; Convierte una cadena a mayusculas
upCase:
        UCCicle:
                mov     al, [esi]		; al = registro de derecha
                cmp     al, 0
                je      finStr			; je = jump if equal
                cmp     al, 'a'
                jl      noMinus			; jump if less than

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

; ---------- loCase ----------
; Convierte una cadena a minusculas
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

; ---------- strInvert ----------
; Invierte la cadena
strInvert:
	start:
		call	strLen
		call	strPrint
		add	esi, eax
		jmp	ciclo
	ciclo:
		mov	al, [esi]
		cmp	al, 0
		je	finStr
		jmp	get
	get:
		mov	[edi], al
		dec	esi
		inc	edi
		jmp	ciclo

; ---------- Quit ----------
; Cerrar el programa
Quit:
	mov	ebx, 0
	mov	eax, 1
	int 	80h
	ret

; ---------- StrLen2(cadena) ----------
; Longitud de cadena y devuelve en eax
strLen2:
	xor     ecx, ecx
CicloLen:
    	cmp     byte [esi + ecx], 0
    	je      returnLen
    	inc     ecx
    	jmp     CicloLen

returnLen:
    	mov     eax, ecx
    	ret

; ---------- SrtInt ----------
; Convierte str a int, resibe el parametro en eax y lo devuelve en eax
convertdecimal:
        push    ecx
        push    esi
        push    ebx

        mov     esi, eax                ;eax = 15 20 +
        mov     eax, 0
        mov     ecx, 0
        mov     edi, 0
convertidor:
        mov     ebx, 0                  ;bx, ebx, bl apuntan a la misma direccion
        mov     bl, [esi + ecx]         ;bl es char
        cmp     bl, 10
        je      fin
        cmp     bl, 0
        je      fin
        cmp     bl, 48     	     	;48 es cero en ascii, saltar si bl es menor a cero
        jl      error
        cmp     bl, 57          	;57 es nueve en ascii, saltar si bl es mayor a 9
        jg      error
        sub     bl, 48         	 	;bl= 49(1) - 48 entonces bl=1 ; segundavuelta = 53(5) - 48 = 5
        add     eax, ebx        	;eax = eax + ebx entonces eax = 0+1 entonces eax = 1    ; segundavuelta= eax=10 + >
        mov     ebx, 10         	; ebx = 10
        mul     ebx             	;eax = eax * ebx entonces eax = 1 * 10 entonces eax= 10         ;segundavuelta = e>
        inc     ecx             	;ecx = 0+1, inc entonces exc = 1 entonces es como esc++
        jmp     convertidor
error:
        mov     edi, 1
        jmp     salirconvertidor
fin:
        mov     ebx, 10
        div     ebx
        jmp     salirconvertidor
salirconvertidor:
        pop     ebx
        pop     esi
        pop     ecx

        ret
