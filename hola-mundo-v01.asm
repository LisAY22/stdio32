; Hola Mundo!
; Autor: lis
; Fecha: 20240803

SECTION .data						; Datos
	msg	db	'Hola Mundo!', 0Ah, 0Dh

SECTION .text						; Codigo
	global _start

_start:
	mov	edx, 13					; edx = 13
	mov	ecx, msg				; ecx = msg
	mov	ebx, 1					; ebx = salida estandar
	mov	eax, 4					; SYS_WRITE
	int 	80h

	mov	ebx, 0					; ebx = la salida se produjo normalmente
	mov	eax, 1					; SYS_EXIT
	int 	80h
