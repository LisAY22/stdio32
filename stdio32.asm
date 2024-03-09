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

; --------- Quit ----------
; Cerrar el programa
Quit:
	mov	ebx, 0
	mov	eax, 1
	int 	80h
	ret
