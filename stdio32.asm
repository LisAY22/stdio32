; Bloque de funciones para entrada y salida estandar
; Autor: lis
; Fecha: 20240308

; ---------- strPrint ----------
; Imprime cadena en pantalla
; Recibe cadena en ebx
; Recibe longitud en eax
strPrint:
	push	edx
	push 	ecx
	push 	ebx
	push 	eax

	pop	eax
	mov	edx, eax
	pop	ebx
	mov	ecx, ebx
	mov	ebx, 1
	mov	eax, 4
	int	80h

	pop	ecx
	pop	edx

	ret

; --------- Quit ----------
; Cerrar el programa
Quit:
	mov	ebx, 0
	mov	eax, 1
	int 	80h
	ret
