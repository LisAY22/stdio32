; Creacion de archivos
; Autor: lis
; Fecha: 20240311

%include 'stdio32.asm'

SECTION .data
	nombrearch	db	'leame.txt', 0

SECTION .text
	global _start

_start:
	mov	ecx, 0777o			; configurando permisos rwx 4aall
	mov	ebx, nombrearch			; nombre del archivo a crear
	mov	eax, 8				; SYS_CREATE
	int 	80h

	call 	Quit
