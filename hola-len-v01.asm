; Hola Mundo con Calculo de Longitud de Cadena
; Autor: lis
; Fecha: 20240803

SECTION .data
	msg	db	'Hola Mundo!', 0Ah, 0Dh

SECTION .text
	global _start

_start:
	mov	ebx, msg
	mov	eax, ebx

siguiente:
	cmp	byte[eax], 0				; Compara
	jz	finciclo				; If
	inc	eax					; Incrementa en 1
	jmp	siguiente				; Ir a siguiente

finciclo:
	sub 	eax, ebx				; eax -= ebx

	mov	edx, eax
	mov	ecx, msg
	mov	ebx, 1
	mov	eax, 4
	int 	80h

	mov	ebx, 0
	mov	eax, 1
	int	80h
