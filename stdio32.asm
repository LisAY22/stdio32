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
	jz	finstrLen
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
        idiv    ebx
        push    edx
        cmp     eax, 0
        jne     divideNumber

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

; ---------- printInLn ----------
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

; ---------- Quit ----------
; Cerrar el programa
Quit:
	mov	ebx, 0
	mov	eax, 1
	int 	80h
	ret
