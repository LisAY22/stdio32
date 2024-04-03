; Eliminar archivo SYS_UNLINK
; Autor: lis
; Fecha: 20240318

%include 'stdio32.asm'

SECTION .data
	archivo		db	'leame.txt', 0

SECTION .text
	global _start

_start:
	mov	ebx, archivo		; Nombre de archivo a eliminar
	mov	eax, 10			; Invocar a SYS_UNLINK
	int 	80h

	call	Quit
