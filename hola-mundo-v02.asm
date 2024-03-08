; Hola Mundo! - Usando Funciones
; Autor: lis
; Fecha: 20240803

%include 'stdio32.asm'					; Importar

SECTION .data
	msg	db 	'Hola Mundo!', 0Ah, 0Dh

SECTION .text
	global _start

_start:
	mov	eax, 13
	mov	ebx, msg
	call 	strPrint

	call	 Quit
